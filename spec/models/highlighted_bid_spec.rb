require 'rails_helper'

describe HighlightedBid do
  describe '#find' do
    context 'no bids for auction' do
      it 'returns null bid' do
        auction = create(:auction)
        user = create(:user)

        bid = HighlightedBid.new(auction: auction, user: user).find

        expect(bid).to be_a(NullBid)
      end
    end

    context 'available single bid auction where user is bidder' do
      it 'returns user lowest bid' do
        auction = create(:auction, :single_bid, :available)
        user = create(:user)
        user_bid = create(:bid, auction: auction, bidder: user)

        bid = HighlightedBid.new(auction: auction, user: user).find

        expect(bid).to eq user_bid
      end
    end

    context 'available single bid auction where is not bigger' do
      it 'returns null bid' do
        auction = create(:auction, :single_bid, :available)
        user = create(:user)
        other_user = create(:user)
        _other_user_bid = create(:bid, auction: auction, bidder: other_user)

        bid = HighlightedBid.new(auction: auction, user: user).find

        expect(bid).to be_a(NullBid)
      end
    end

    context 'multi bid auction' do
      it 'returns the lowest bid' do
        auction = create(:auction, :multi_bid, :available)
        user = create(:user)
        other_user = create(:user)
        _high_bid = create(:bid, amount: 100, auction: auction, bidder: user)
        low_bid = create(:bid, amount: 50, auction: auction, bidder: other_user)

        bid = HighlightedBid.new(auction: auction, user: user).find

        expect(bid).to eq(low_bid)
      end
    end

    context 'closed auction' do
      it 'returns the lowest bid' do
        auction = create(:auction, :single_bid, :closed)
        user = create(:user)
        other_user = create(:user)
        _high_bid = create(:bid, amount: 100, auction: auction, bidder: user)
        low_bid = create(:bid, amount: 50, auction: auction, bidder: other_user)

        bid = HighlightedBid.new(auction: auction, user: user).find

        expect(bid).to eq(low_bid)
      end
    end
  end
end
