require 'rails_helper'

RSpec.describe User do
  describe 'named scopes' do
    describe '.blank_name' do
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
