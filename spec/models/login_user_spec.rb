require 'rails_helper'

describe LoginUser do
  context 'when the uid exists in a user' do
    it 'does not create a new user' do
      FactoryGirl.create(:user, github_id: github_id_from_oauth)
      authenticator = LoginUser.new(auth_hash, {})
      expect { authenticator.perform }.not_to change { User.count }
    end

    it 'updates the user with additional data' do
      user = FactoryGirl.create(:user)
      allow(User).to receive(:find_or_create_by).with(github_id: github_id_from_oauth).and_return(user)
      authenticator = LoginUser.new(auth_hash, {})
      allow(user).to receive(:from_oauth_hash).with(auth_hash)

      authenticator.perform

      expect(user).to have_received(:from_oauth_hash).with(auth_hash)
    end

    it 'signs in the user into the session' do
      user = FactoryGirl.create(:user, github_id: github_id_from_oauth)
      session = {}
      authenticator = LoginUser.new(auth_hash, session)

      authenticator.perform

      expect(session[:user_id]).to eq(user.id)
    end
  end

  context 'when the uid does not exist' do
    it 'creates a new user' do
      authenticator = LoginUser.new(auth_hash, {})

      expect { authenticator.perform }.to change { User.count }
    end

    it 'signs in the user into the session' do
      user = FactoryGirl.create(:user, github_id: github_id_from_oauth)
      session = {}
      authenticator = LoginUser.new(auth_hash, session)

      authenticator.perform

      expect(session[:user_id]).to eq(user.id)
    end
  end

  def auth_hash
    OmniAuth::AuthHash.new(
      provider: 'github',
      uid: github_id_from_oauth,
      info: {
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
