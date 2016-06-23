require 'rails_helper'

describe PlaceBid do
  describe '#valid?' do
    it 'converts numbers with commas to integers' do
      user = create(:user, sam_status: :sam_accepted)
      auction = create(:auction, :reverse, :available)
      create(:bid, amount: 1000, auction: auction)
      params = { auction_id: auction.id, bid: { amount: '2,000' } }

      place_bid = PlaceBid.new(params: params, bidder: user)

      expect(place_bid).not_to be_valid
    end

    it 'is true when bid is valid' do
      user = create(:user, sam_status: :sam_accepted)
      auction = create(:auction, :sealed_bid, :available)
      params = { auction_id: auction.id, bid: { amount: 10 } }

      place_bid = PlaceBid.new(params: params, bidder: user)

      expect(place_bid).to be_valid
    end

    it 'is false when bid is invalid' do
      user = create(:user, sam_status: :sam_accepted)
      auction = create(:auction, :sealed_bid, :available)
      params = { auction_id: auction.id, bid: { amount: 100000 } }

      place_bid = PlaceBid.new(params: params, bidder: user)

      expect(place_bid).not_to be_valid
    end
  end

  describe '#perform' do
    context 'valid bid' do
      it 'creates a bid' do
        user = create(:user, sam_status: :sam_accepted)
        auction = create(:auction, :sealed_bid, :available)
        params = { auction_id: auction.id, bid: { amount: 10 } }

        place_bid = PlaceBid.new(params: params, bidder: user)
        bid = place_bid.bid

        expect { place_bid.perform }.to change { Bid.count }.by(1)
        expect(bid.auction).to eq(auction)
        expect(bid.bidder).to eq(user)
      end
    end

    context 'invalid bid' do
      it 'does not create a bid' do
        user = create(:user)
        auction = create(:auction, :sealed_bid, :available)
        params = { auction_id: auction.id, bid: { amount: -10 } }

        place_bid = PlaceBid.new(params: params, bidder: user)

        expect { place_bid.perform }.to change { Bid.count }.by(0)
      end
    end
  end
end
