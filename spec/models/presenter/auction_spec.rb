require 'rails_helper'

RSpec.describe Presenter::Auction do
  let(:auction) { Presenter::Auction.new(ar_auction) }
  let(:ar_auction) { FactoryGirl.create(:auction) }

  describe '#current_bid when there are no bids' do
    it 'return a null bid' do
      expect(auction.current_bid).to be_a(Presenter::Bid::Null)
    end
  end

  describe '#current_bid when there is only one bid in the timeframe' do
    let!(:bid) { FactoryGirl.create(:bid, auction_id: ar_auction.id) }

    it 'return that bid' do
      expect(auction.current_bid).to eq(bid)
    end
  end

  describe '#current_bid when there are multiple bids of different amounts' do
    let!(:bids) {
      [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 20),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10)
      ]
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids.last)
    end
  end

  describe '#current_bid when there are multiple bids with the same amount' do
    let!(:bids) {
      collection = [
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00),
        FactoryGirl.create(:bid, auction_id: ar_auction.id, amount: 10.00)
      ]
      collection[1].update_attribute(:created_at, (Time.now - 3.hours).utc)
      collection
    }

    it 'return the bid with the lowest amount' do
      expect(auction.current_bid).to eq(bids[1])
    end
  end

  describe '#available?' do
    context 'when the auction has expired' do
      let(:ar_auction) { FactoryGirl.create(:closed_auction) }

      it 'should be false' do
        expect(auction.available?).to eq(false)
      end
    end

    context 'when the auction has not started yet' do
      let(:ar_auction) { FactoryGirl.create(:future_auction) }

      it 'should be false' do
        expect(auction.available?).to eq(false)
      end
    end

    context 'when between dates' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should be false' do
        expect(auction.available?).to eq(true)
      end
    end
  end
end
