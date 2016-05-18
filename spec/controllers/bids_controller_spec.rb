require 'rails_helper'

RSpec.describe BidsController, controller: true do
  let(:current_bidder) { create(:user, sam_status: :sam_accepted) }
  let(:auction) { create(:auction) }

  describe '/my-bids' do
    context 'when logged out' do
      it 'should redirect to /login' do
        get :new, auction_id: auction.id
        expect(response).to redirect_to("/login")
      end
    end

    context 'when logged in' do
      it 'should assign auctions that current user have bidded on, presented' do
        bid = auction.bids.create(bidder_id: current_bidder.id)
        expect(bid).to be_valid
        get :my_bids, { }, user_id: current_bidder.id
        assigned_bid = assigns(:bids).first
        expect(assigned_bid).to be_a(BidPresenter)
        expect(assigned_bid.id).to eq(bid.id)
      end

      it 'should not assign auctions that the current user has not bidded on' do
        auction.bids.create(bidder_id: current_bidder.id + 127)
        get :my_bids, { }, user_id: current_bidder.id
        expect(assigns(:bids)).to be_empty
      end
    end
  end

  describe '#new' do
    context 'when logged in' do
      it 'should render the bid information' do
        get :new, { auction_id: auction.id }, user_id: current_bidder.id
        expect(response).to render_template(:new)
      end

      context 'when the auction is published' do
        let(:auction) { create(:auction, :published) }

        it 'renders the template' do
          get :new, { auction_id: auction.id }, user_id: current_bidder.id
          expect(response).to render_template(:new)
        end
      end

      context 'when the auction is unpublished' do
        let(:auction) { create(:auction, :unpublished) }

        it 'should raise a routing error' do
          expect do
            get :new, { auction_id: auction.id }, user_id: current_bidder.id
          end.to raise_error ActionController::RoutingError
        end
      end
    end

    context 'when logged out' do
      it 'should redirect to /login' do
        get :new, auction_id: auction.id
        expect(response).to redirect_to("/login")
      end

      context 'when the auction is published' do
        let(:auction) { create(:auction, :published) }

        it 'renders the template' do
          get :new, auction_id: auction.id
          expect(response).to redirect_to("/login")
        end
      end

      context 'when the auction is unpublished' do
        let(:auction) { create(:auction, :unpublished) }

        it 'should raise a routing error' do
          get :new, auction_id: auction.id
          expect(response).to redirect_to("/login")
        end
      end
    end
  end

  describe '#index' do
    context 'when logged in' do
      it 'renders the template' do
        get :index, { auction_id: auction.id }, user_id: current_bidder.id
        expect(response).to render_template(:index)
      end
    end

    context 'when logged out' do
      it 'renders the template' do
        get :index, auction_id: auction.id
        expect(response).to render_template(:index)
      end
    end

    context 'when the auction is published' do
      let(:auction) { create(:auction, :published) }

      it 'renders the template' do
        get :index, auction_id: auction.id
        expect(response).to render_template(:index)
      end
    end

    context 'when the auction is unpublished' do
      let(:auction) { create(:auction, :unpublished) }

      it 'should raise a routing error' do
        expect do
          get :index, auction_id: auction.id
        end.to raise_error ActionController::RoutingError
      end
    end
  end

  describe '#create' do
    context 'when not logged in' do
      it 'redirects to authenticate' do
        post :create, auction_id: auction.id, bid: { amount: 1000.00 }
        expect(response).to redirect_to("/login")
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

          bid = auction.bids.order('created_at DESC').first
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
          expect(flash[:error]).to eq("Bid amount out of range")
          expect(response).to redirect_to("/auctions/#{auction.id}/bids/new")
        end
      end
    end
  end
end
