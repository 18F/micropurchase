require 'rails_helper'

describe UsersController do
  describe '#update' do
    it 'redirects to authenticate when not logged in' do
      put :update, id: user.id, user: { duns_number: '222' }
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/sign_in')
    end

    it 'uses the UpdateUser class to update the user' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(false)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
    end

    it 'rerenders edit when the update fails' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(false)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
      expect(response).to render_template(:edit)
    end

    it 'redirects back home after successful edit' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(true)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/')
    end
  end

  describe '#bids_placed' do
    context 'when logged in' do
      it 'should assign auctions that current user have bidded on, presented' do
        current_bidder = create(:user, sam_status: :sam_accepted)
        auction = create(:auction)
        bid = create(:bid, bidder: current_bidder, auction: auction)
        expect(bid).to be_valid
        get :bids_placed, { }, user_id: current_bidder.id
        view_model = assigns(:view_model)
        expect(view_model).to_not be_nil
        expect(view_model.auctions).to_not be_empty
      end

      it 'should not assign auctions that the current user has not bidded on' do
        current_bidder = create(:user, sam_status: :sam_accepted)
        auction = create(:auction)
        other_person = create(:user)
        create(:bid, bidder: other_person, auction: auction)
        get :bids_placed, { }, user_id: current_bidder.id
        view_model = assigns(:view_model)
        expect(view_model).to_not be_nil
        expect(view_model.auctions).to be_empty
      end
    end
  end



  def user
    @_user ||= create(:user)
  end
end
