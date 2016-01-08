require 'rails_helper'

RSpec.describe UpdateUser do
  describe '#perform' do
    let(:user) { FactoryGirl.create(:user, sam_account: false) }
    let(:user_with_duns) do
      FactoryGirl.create(:user, :with_duns_in_sam, sam_account: true)
    end
    let(:params) do
      {
        "id" => user.id
      }
    end

    context 'when updating the DUNS number (and one had already been there)' do
      it 'should set sam_account to false' do
        expect(user_with_duns.sam_account).to be(true)

        params['duns_number'] = '08-011-5718'
        UpdateUser.(user_with_duns, params.perform)
        user.reload

        expect(user.sam_account).to be(false)
      end
    end

    context 'when adding the DUNS number for the first time' do
      it 'should keep sam_account set to false' do
        expect(user.sam_account).to be(false)

        params['duns_number'] = '08-011-5718'
        UpdateUser.(user_with_duns, params.perform)
        user.reload

        expect(user.sam_account).to be(false)
      end
    end

    context 'when updating attributes other than DUNS number' do
      it 'should not change sam_account' do
        expect(user.sam_account).to be(false)

        params['email'] = 'fake@gmail.com'
        UpdateUser.(user, params.perform)
        user.reload

        expect(user.sam_account).to be(false)
      end
    end
    # 
    # it 'should be set to false if the DUNS number is changed' do
    #   u = FactoryGirl.create(:user)
    #   expect(u).to be_sam_account
    #
    #   u.duns_number = Faker::Company.duns_number
    #   u.save!
    #
    #   expect(u).to_not be_sam_account
    # end
  end
end
