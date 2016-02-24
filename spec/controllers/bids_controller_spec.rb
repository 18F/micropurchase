require 'rails_helper'

RSpec.describe BidsController, controller: true do
  let(:current_bidder) { FactoryGirl.create(:user) }
  let(:auction) { FactoryGirl.create(:auction) }

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
        get :my_bids, {}, user_id: current_bidder.id
        assigned_bid = assigns(:bids).first
        expect(assigned_bid).to be_a(Presenter::Bid)
        expect(assigned_bid.id).to eq(bid.id)
      end

      it 'should not assign auctions that the current user has not bidded on' do
        auction.bids.create(bidder_id: current_bidder.id + 127)
        get :my_bids, {}, user_id: current_bidder.id
        expect(assigns(:bids)).to be_empty
      end
    end
  end

  describe '#new' do
    context 'when logged in' do
      it 'should render the bid information' do
        get :new, {auction_id: auction.id}, user_id: current_bidder.id
        expect(response).to render_template(:new)
      end

      context 'when the auction is published' do
        let(:auction) { FactoryGirl.create(:auction, :published) }

        it 'renders the template' do
          get :new, {auction_id: auction.id}, user_id: current_bidder.id
          expect(response).to render_template(:new)
        end
      end

      context 'when the auction is unpublished' do
        let(:auction) { FactoryGirl.create(:auction, :unpublished) }

        it 'should raise a routing error' do
          expect do
            get :new, {auction_id: auction.id}, user_id: current_bidder.id
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
        let(:auction) { FactoryGirl.create(:auction, :published) }

        it 'renders the template' do
          get :new, auction_id: auction.id
          expect(response).to redirect_to("/login")
        end
      end

      context 'when the auction is unpublished' do
        let(:auction) { FactoryGirl.create(:auction, :unpublished) }

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
        get :index, {auction_id: auction.id}, user_id: current_bidder.id
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
      let(:auction) { FactoryGirl.create(:auction, :published) }

      it 'renders the template' do
        get :index, auction_id: auction.id
        expect(response).to render_template(:index)
      end
    end

    context 'when the auction is unpublished' do
      let(:auction) { FactoryGirl.create(:auction, :unpublished) }

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
        post :create, auction_id: auction.id, bid: {amount: 1000.00}
        expect(response).to redirect_to("/login")
      end
    end

    context 'when there are no other bids' do
      before do
        allow(controller).to receive(:current_user).and_return(current_bidder)
        allow(PlaceBid).to receive(:new).and_return(place_bid)
      end

      let(:bid) { auction.bids.first }
      let(:place_bid) { double('place bid object', perform: true) }
      let(:request_params) do
        {
          auction_id: auction.id,
          bid: {amount: 3000.50}
        }
      end

      it "creates creates a bid and redirects to the new bid page" do
        expect(PlaceBid).to receive(:new).with(anything, current_bidder).and_return(place_bid)
        post :create, request_params
        expect(flash[:bid]).to eq("success")
        expect(response).to redirect_to("/auctions/#{auction.id}")
      end

      it "adds a flash error when the bid is bad" do
        expect(PlaceBid).to receive(:new).with(anything, current_bidder)
          .and_raise(UnauthorizedError.new("Bad bid, sucker!"))
        post :create, request_params
        expect(flash[:error]).to eq("Bad bid, sucker!")
        expect(response).to redirect_to("/auctions/#{auction.id}/bids/new")
      end
    end
  end
end
