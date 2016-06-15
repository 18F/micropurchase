require 'rails_helper'

describe LoginUser do
  describe '#perform' do
    context 'user does not have github username, name, or email' do
      it 'updates from auth hash' do
        github_id = '1234'
        user = build(:user, github_login: nil, name: '', email: '', github_id: github_id)
        user.save(validate: false)
        auth_hash = {
          uid: github_id,
          info: {
            nickname: 'github_username',
            name: 'Person',
            email: 'test@example.com'
          }
        }

        login_user = LoginUser.new(auth_hash, {})
        login_user.perform

        user.reload

        expect(user.github_login).to eq 'github_username'
        expect(user.name).to eq 'Person'
        expect(user.email).to eq 'test@example.com'
      end
    end

    context 'user already has github username, name, and email' do
      it 'does not update email, name, does update github username' do
        github_id = '1234'
        user = create(
          :user,
          github_login: 'Old_Username',
          name: 'Old name',
          email: 'oldemail@example.com',
          github_id: github_id
        )
        auth_hash = {
          uid: github_id,
          info: {
            nickname: 'New_Username',
            name: 'New name',
            email: 'test@example.com'
          }
        }

        login_user = LoginUser.new(auth_hash, {})
        login_user.perform

        user.reload

        expect(user.github_login).to eq 'New_Username'
        expect(user.name).to eq 'Old name'
        expect(user.email).to eq 'oldemail@example.com'
      end
    end

    context 'when the uid exists in a user' do
      it 'does not create a new user' do
        FactoryGirl.create(:user, github_id: github_id_from_oauth)
        authenticator = LoginUser.new(auth_hash, { })
        expect { authenticator.perform }.not_to change { User.count }
      end

      it 'signs in the user into the session' do
        user = FactoryGirl.create(:user, github_id: github_id_from_oauth)
        session = { }
        authenticator = LoginUser.new(auth_hash, session)

        authenticator.perform

        expect(session[:user_id]).to eq(user.id)
      end
    end

    context 'when the uid does not exist' do
      it 'creates a new user' do
        authenticator = LoginUser.new(auth_hash, { })

        expect { authenticator.perform }.to change { User.count }
      end

      it 'signs in the user into the session' do
        user = FactoryGirl.create(:user, github_id: github_id_from_oauth)
        session = { }
        authenticator = LoginUser.new(auth_hash, session)

        authenticator.perform

        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  def auth_hash
    OmniAuth::AuthHash.new(
      provider: 'github',
      uid: github_id_from_oauth,
      info: {
        nickname: 'github_username',
        name: 'Kane',
        email: 'email@example.com',
        image: 'github-image.png'
      }
    )
  end

  def github_id_from_oauth
    '12345'
  end
end
