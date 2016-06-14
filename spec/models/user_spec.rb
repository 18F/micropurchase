require 'rails_helper'

describe User do
  describe "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:github_id) }
    it { should validate_presence_of(:github_login) }
    it { should validate_presence_of(:sam_status) }

    describe 'duns number validations' do
      context 'duns is 13 chars long' do
        it 'is valid' do
          user = build(:user, duns_number: '1234567890123')

          expect(user).to be_valid
        end
      end

      context 'duns is nil' do
        it 'is valid' do
          user = build(:user, duns_number: nil)

          expect(user).to be_valid
        end
      end

      context 'duns is empty string' do
        it 'is invalid' do
          user = build(:user, duns_number: '')

          expect(user).not_to be_valid
        end
      end
    end
  end
end
