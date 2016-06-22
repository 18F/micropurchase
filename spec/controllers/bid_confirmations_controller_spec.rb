require 'rails_helper'

describe BidConfirmationsController do
  describe '#create' do
    context 'bid is bad' do
      it "adds a flash error when the bid is bad" do
        current_bidder = create(:user, sam_status: :sam_accepted)
        auction = create(:auction)
        request_params = { auction_id: auction.id, bid: { amount: -192 } }

        post :create, request_params, user_id: current_bidder.id

        expect(flash[:error]).to eq("Bid amount out of range")
        expect(response).to redirect_to(auction_path(auction))
      end
    end
  end
end
