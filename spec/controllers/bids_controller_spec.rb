require 'rails_helper'

RSpec.describe BidsController, controller: true do
  let(:current_bidder) { User.create(github_id: '12345')}
  let(:auction) {
    Auction.create({
      title: 'Refactor this disaster',
      start_datetime: Time.now - 4.days,
      end_datetime: Time.now + 3.days
    })
  }

  describe '#index' do
    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'should redirect to /login' do
        get :new, auction_id: auction.id
        expect(response).to redirect_to("/login")
      end
    end

    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user).and_return(current_bidder)
      end

      it 'should assign auctions that current user have bidded on, presented' do
        bid = auction.bids.create(bidder_id: current_bidder.id)
        get :index
        assigned_auction = assigns(:auctions).first
        expect(assigned_auction).to be_a(Presenter::Auction)
        expect(assigned_auction.id).to eq(auction.id)
      end

      it 'should not assign auctions that the current user has not bidded on' do
        auction.bids.create(bidder_id: 123)
        get :index
        expect(assigns(:auctions)).to be_empty
      end
    end
  end

  describe '#new' do
    context 'when logged in' do
      before do
        allow(controller).to receive(:current_user).and_return(current_bidder)
      end

      it 'should render the bid information' do
        get :new, auction_id: auction.id
        expect(response).to render_template(:new)
      end
    end

    context 'when logged out' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'should redirect to /login' do
        get :new, auction_id: auction.id
        expect(response).to redirect_to("/login")
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
      let(:request_params) {
        {
          auction_id: auction.id,
          bid: {amount: 3000.50}
        }
      }

      it "creates creates a bid and redirects to the new bid page" do
        expect(PlaceBid).to receive(:new).with(anything, current_bidder).and_return(place_bid)
        post :create, request_params
        expect(response).to redirect_to("/auctions/#{auction.id}/bids/new")
      end

      it "adds a flash error when the bid is bad" do
        expect(PlaceBid).to receive(:new).with(anything, current_bidder).and_raise(UnauthorizedError.new("Bad bid, sucker!"))
        post :create, request_params
        expect(flash[:error]).to eq("Bad bid, sucker!")
        expect(response).to redirect_to("/auctions/#{auction.id}/bids/new")
      end
    end
  end
end
