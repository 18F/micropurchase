require 'rails_helper'

RSpec.describe User do
  describe 'sam_account?' do
    it 'should be set to false if the DUNS number is changed' do
      u = FactoryGirl.create(:user)
      expect(u).to be_sam_account

      u.duns_number = Faker::Company.duns_number
      u.save!

      expect(u).to_not be_sam_account
    end
  end
end
