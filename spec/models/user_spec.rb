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
end
