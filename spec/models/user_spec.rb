require 'rails_helper'

describe User do
  describe "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:sam_status) }

    describe 'github validations' do
      context 'user has a uid' do
        it 'does not validate github id and name presence' do
          user = build(:user, uid: '1234', github_id: nil, github_login: nil)

          expect(user).to be_valid
        end
      end

      context 'user does not have a uid' do
        it 'validates github id and name' do
          user = build(:user, uid: nil, github_id: nil, github_login: nil)

          expect(user).to be_invalid
          expect(user.errors.full_messages).to eq(
            ["Github can't be blank", "Github login can't be blank"]
          )
        end
      end
    end

    describe 'duns number validations' do
      context 'duns is 13 chars long' do
        it 'is valid' do
          user = build(:user, duns_number: '1234567890123')

          expect(user).to be_valid
        end
      end

      context 'duns is empty string' do
        it 'is valid' do
          user = build(:user, duns_number: '')

          expect(user).to be_valid
        end
      end
    end
  end

  describe '.from_saml_omniauth' do
    context 'user with saml uid exists' do
      context 'user is an admin' do
        context 'provided auth uid is not empty' do
          it 'returns the user' do
            uid = '1234'
            info = double(email: '', first_name: '', last_name: '')
            auth_data = double(uid: uid, info: info)
            admin = create(:admin_user, uid: uid)

            expect(User.from_saml_omniauth(auth_data)).to eq admin
          end
        end

        context 'provied auth uid is empty string' do
          it 'returns nil' do
            uid = ''
            info = double(email: '', first_name: '', last_name: '')
            auth_data = double(uid: uid, info: info)
            _admin = create(:admin_user, uid: uid)

            expect(User.from_saml_omniauth(auth_data)).to eq nil
          end
        end
      end

      context 'user is not an admin' do
        it 'returns nil' do
          uid = '1234'
          info = double(email: '', first_name: '', last_name: '')
          auth_data = double(uid: uid, info: info)
          _user = create(:user, uid: uid)

          expect(User.from_saml_omniauth(auth_data)).to eq nil
        end
      end
    end

    context 'user with uid does not exist' do
      context 'user with auth email exists' do
        context 'user with auth email is admin' do
          it 'updates the existing user with the uid and returns the user' do
            uid = '1234'
            email = 'test@example.com'
            info = double(email: email, first_name: '', last_name: '')
            auth_data = double(uid: uid, info: info)
            admin = create(:admin_user, uid: '', email: email)

            expect(User.from_saml_omniauth(auth_data)).to eq admin
            expect(admin.reload.uid).to eq uid
          end
        end

        context 'user with auth email is not an admin' do
          it 'returns nil' do
            email = 'test@example.com'
            info = double(email: email, first_name: '', last_name: '')
            auth_data = double(uid: '', info: info)
            _user = create(:user, email: email)

            expect(User.from_saml_omniauth(auth_data)).to eq nil
          end
        end
      end

      context 'user with auth email does not exist' do
        it 'returns nil' do
          email = 'test@example.com'
          info = double(email: email, first_name: '', last_name: '')
          auth_data = double(uid: '', info: info)

          expect(User.from_saml_omniauth(auth_data)).to eq nil
        end
      end
    end
  end
end
