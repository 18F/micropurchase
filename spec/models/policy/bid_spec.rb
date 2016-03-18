require 'rails_helper'

RSpec.describe Policy::Bid, type: :model do
  let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }
  let(:ar_bids) { ar_auction.bids.sort_by(&:amount) }
  let(:win_auction) { Policy::Auction.factory(ar_auction, ar_bids.first.bidder) }
  let(:win_bid) { Policy::Bid.new(ar_bids.first, win_auction) }
  let(:lose_auction) { Policy::Auction.factory(ar_auction, ar_bids.last.bidder) }
  let(:lose_bid) { Policy::Bid.new(ar_bids.last, lose_auction) }
    
  describe 'amount_to_currency_with_asterix' do
    it 'should return true if the bid is a winning one' do
      expect(win_bid.amount_to_currency_with_asterisk).to eq("#{win_bid.amount_to_currency} *")
    end

    it 'should return false if the bid is not a winning one' do
      expect(lose_bid.amount_to_currency_with_asterisk).to eq(lose_bid.amount_to_currency)
    end
  end
  
  describe 'is_winning?' do
    it 'should return true when the bid is a winning one' do
      expect(win_bid.is_winning?).to be_truthy
    end

    it 'should return false when the bid is not winning' do
      expect(lose_bid.is_winning?).to be_falsey
    end
  end

  describe 'equality' do
    it 'should be true when wrapping the same bid object' do
      win_bid2 = Policy::Bid.new(ar_bids.first, win_auction)
      expect(win_bid).to eq(win_bid2)
    end
  end
end
