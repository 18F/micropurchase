require_relative '../feature_helper'

RSpec.describe 'Auction bids, REST style' do
  let(:current_bidder) { User.create(github_id: '12345')}
  let(:auction) { Auction.create(title: 'Refactor this disaster') }

  describe '/auctions/:auction_id/bids/new' do
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

  describe 'post /actions/:auction_id/bids' do
    context 'when there are no other bids' do
      it 'render success' do
        post "/auctions/#{auction.id}/bids", {amount: 3000.00}, session_authentication
        expect(last_response.body).to include('Bid Submitted!')
      end

      it "creats a bid for the current user and is the current bid"
    end

    context 'when the bid is lower than the current bid' do
    end

    context 'when the bid is higher than the current bid' do
    end

    context 'when the bid is the same as current bid' do
    end
  end
end
