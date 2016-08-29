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

      context 'duns is empty string' do
        it 'is valid' do
          user = build(:user, duns_number: '')

          expect(user).to be_valid
        end
      end
    end
  end

  describe '#admin?' do
    it 'should return true if the user is an admin' do
      user = create(:user)
      expect(user).to_not be_admin
    end

    it 'should return false if the user is not an admin' do
      user = create(:admin_user)
      expect(user).to be_admin
    end
  end
end
