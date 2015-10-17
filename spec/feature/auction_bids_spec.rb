require_relative '../feature_helper'

RSpec.describe 'Auction bids, REST style' do
  describe '/auctions/:auction_id/bids/new' do
    let(:current_bidder) { Bidder.create(github_id: '12345')}
    let(:auction) { Auction.create(title: 'Refactor this disaster') }

    context 'when there are no bids' do
      it 'should render the bid information' do
        get "/auctions/#{auction.id}/bids/new", {}, session_authentication
        expect(last_response.body).to include("Refactor this disaster")
      end
    end

    context 'when there is already a bid by other person' do
      before do
        auction.bids.create(bidder_id: current_bidder.id + 1000, amount: 1000.50)
      end

      it 'should render the bid information' do
        get "/auctions/#{auction.id}/bids/new", {}, session_authentication
        expect(last_response.body).to include("Refactor this disaster")
      end

      it 'should let the current user know the current bid' do
        get "/auctions/#{auction.id}/bids/new", {}, session_authentication
        expect(last_response.body).to include("$1,000.50")
      end
    end

    context 'when there is already a bid by current user' do
      before do
        auction.bids.create(bidder_id: current_bidder.id, amount: 1000.50)
      end

      it 'should render the bid information' do
        get "/auctions/#{auction.id}/bids/new", {}, session_authentication
        expect(last_response.body).to include("Refactor this disaster")
      end

      it 'should maybe do something slightly different??'
    end
  end
end
