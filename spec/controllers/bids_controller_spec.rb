require 'rails_helper'

describe BidsController do
  let(:current_bidder) { create(:user, sam_status: :sam_accepted) }
  let(:auction) { create(:auction) }

  describe '#index' do
    context 'when logged in' do
      it 'should assign auctions that current user have bidded on, presented' do
        current_bidder = create(:user, sam_status: :sam_accepted)
        auction = create(:auction)
        bid = create(:bid, bidder: current_bidder, auction: auction)
        expect(bid).to be_valid

        get :index, { }, user_id: current_bidder.id

        view_model = assigns(:view_model)
        expect(view_model).to_not be_nil
        expect(view_model.auctions).to_not be_empty
      end

      it 'should not assign auctions that the current user has not bidded on' do
        current_bidder = create(:user, sam_status: :sam_accepted)
        auction = create(:auction)
        other_person = create(:user)
        create(:bid, bidder: other_person, auction: auction)

        get :index, { }, user_id: current_bidder.id

        view_model = assigns(:view_model)
        expect(view_model).to_not be_nil
        expect(view_model.auctions).to be_empty
      end
    end
  end

  describe '#create' do
    context 'when not logged in' do
      it 'redirects to authenticate' do
        post :create, auction_id: auction.id, bid: { amount: 1000.00 }
        expect(response).to redirect_to(sign_in_path)
      end
    end

    context 'when there are no other bids' do
      let(:bid) { auction.bids.first }
      let(:request_params) do
        {
          auction_id: auction.id,
          bid: { amount: 1000 }
        }
      end

      context 'when the bid is good' do
        it "creates a bid and redirects to the new bid page" do
          post :create, request_params, user_id: current_bidder.id
          expect(flash[:bid]).to eq("success")
          expect(response).to redirect_to("/auctions/#{auction.id}")

          bid = auction.bids.last
          expect(bid.bidder).to eq(current_bidder)
          expect(bid.amount).to eq(1000)
          expect(bid.via).to eq('web')
        end
      end

      context 'when the bid is bad' do
        let(:request_params) do
          {
            auction_id: auction.id,
            bid: { amount: -192 }
          }
        end

        it "adds a flash error when the bid is bad" do
          post :create, request_params, user_id: current_bidder.id
          expect(flash[:bid_error]).to eq("Bid amount out of range")
          expect(response).to redirect_to(auction_path(auction))
        end
      end
    end
  end
end
