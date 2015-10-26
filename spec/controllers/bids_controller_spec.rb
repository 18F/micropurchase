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
      end

      let(:bid) { auction.bids.first }

      it "creats a bid for the current user and is the current bid" do
        post :create, auction_id: auction.id, bid: {amount: 3000.50}
        expect(bid.bidder).to eq(current_bidder)
        expect(bid.amount).to eq(3000.50)
      end

      it 'redirects them back to the new bid page' do
        post :create, auction_id: auction.id, bid: {amount: 3000.50}
        expect(response).to redirect_to("/auctions/#{auction.id}/bids/new")
      end
    end
  end
end
