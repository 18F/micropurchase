require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:auction) { Presenter::Auction.new(ar_auction_mock) }
  let(:ar_auction_mock) {
    double('AR Auction', {
      bids: bids,
      start_datetime: Time.now - 1.day,
      end_datetime: Time.now + 1.day
    })
  }

  describe '#current_bid when there are no bids' do
    let(:bids) { [] }

    it 'return nil' do
      expect(auction.current_bid).to be_nil
    end
  end

  describe '#current_bid when there is only one bid in the timeframe' do
    let(:bid) { Bid.create }
    let(:bids) { [bid] }

    it 'return that bid' do
      expect(auction.current_bid).to eq(bid)
    end
  end

  describe '#current_bid when there are multiple bids of different amounts' do
    let(:bids) {
      [
        Bid.create(amount: 20.00),
        Bid.create(amount: 10.00)
      ]
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids.last)
    end
  end

  describe '#current_bid when there are multiple bids with the same amount' do
    let(:bids) {
      collection = [
        Bid.create(amount: 10.00),
        Bid.create(amount: 10.00),
        Bid.create(amount: 10.00)
      ]
      collection[1].update_attribute(:created_at, (Time.now - 3.hours).utc)
      collection
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids[1])
    end
  end
end
