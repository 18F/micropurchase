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

  describe 'named scopes' do
    describe 'not_in_sam' do
      it 'should return users where sam_account is false' do
        u = FactoryGirl.create(:user, sam_account: false)
        expect(User.not_in_sam).to include(u)
      end

      it 'should not return users where sam_account is true' do
        u = FactoryGirl.create(:user, sam_account: true)
        expect(User.not_in_sam).to_not include(u)
      end
    end

    describe 'blank_name' do
      it 'should return NULL names' do
        u = FactoryGirl.create(:user)
        u.update_attribute(:name, nil)

        expect(User.blank_name).to include(u)
      end

      it 'should return blank string names' do
        u = FactoryGirl.create(:user, name: '')
        expect(User.blank_name).to include(u)
      end

      it 'should not return set names' do
        u = FactoryGirl.create(:user)
        expect(u.name).to_not be_blank
        expect(User.blank_name).to_not include(u)
      end
    end
  end
end
