require 'rails_helper'

describe Rules::SealedBid do
  describe '#winning_bid' do
    context 'if the auction if open' do
      it 'returns a NullBidPresenter object' do
        auction = create(:auction, :single_bid, :with_bidders)
        rules = Rules::SealedBid.new(auction)
        expect(rules.winning_bid).to be_a(NullBidPresenter)
      end
    end

    context 'if the auction is over' do
      it "returns the auction's lowest bid" do
        auction = create(:auction, :single_bid, :with_bidders, :closed)
        rules = Rules::SealedBid.new(auction)
        expect(rules.winning_bid).to eq(auction.lowest_bid)
      end
    end
  end

  describe '#veiled_bids' do
    context 'if the auction is open' do
      context 'if the user made a bid' do
        it "should return only the user's bid" do
          auction = create(:auction, :single_bid, :with_bidders)
          user = auction.bids.first.bidder
          rules = Rules::SealedBid.new(auction)
          expect(rules.veiled_bids(user)).to eq([auction.bids.first])
        end
      end

      context 'if the user did not bid' do
        it 'should return an empty array' do
          auction = create(:auction, :single_bid)
          user = create(:user)
          rules = Rules::SealedBid.new(auction)
          expect(rules.veiled_bids(user)).to eq([])
        end
      end
    end

    context 'if the auction is over' do
      it 'should return all bids' do
        user = create(:user)
        auction = create(:auction, :single_bid, :with_bidders, :closed)
        rules = Rules::SealedBid.new(auction)
        expect(rules.veiled_bids(user)).to eq(auction.bids)
      end
    end
  end

  describe '#highlighted_bid' do
    context 'when the auction is over' do
      it 'should return the lowest bid' do
        auction = create(:auction, :single_bid, :with_bidders, :closed)
        user = create(:user)
        rules = Rules::SealedBid.new(auction)
        expect(rules.highlighted_bid(user)).to eq(auction.lowest_bid)
      end
    end

    context 'when the auction is running' do
      context 'when the user has placed a bid' do
        it "should return the user's bid" do
          auction = create(:auction, :single_bid, :with_bidders)
          user = auction.bids.first.bidder
          rules = Rules::SealedBid.new(auction)
          expect(rules.highlighted_bid(user)).to eq(auction.bids.first)
        end
      end

      context 'when the user has not placed a bid' do
        it 'should return a NullBidPresenter object' do
          auction = create(:auction, :single_bid, :with_bidders)
          user = create(:user)
          rules = Rules::SealedBid.new(auction)
          expect(rules.highlighted_bid(user)).to be_a(NullBidPresenter)
        end
      end
    end
  end

  describe '#user_can_bid?' do
    context 'when the user has placed a bid' do
      it 'should return false' do
        auction = create(:auction, :single_bid, :with_bidders)
        user = auction.bids.first.bidder
        rules = Rules::SealedBid.new(auction)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user has not placed a bid' do
      it 'should return true' do
        auction = create(:auction, :single_bid)
        user = create(:user, sam_status: :sam_accepted)
        rules = Rules::SealedBid.new(auction)
        expect(rules.user_can_bid?(user)).to be_truthy
      end
    end
  end

  describe '#max_allowed_bid' do
    it 'should return BID_INCREMENT below the start price' do
        auction = create(:auction, :single_bid)
        rules = Rules::SealedBid.new(auction)
      expect(rules.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
    end
  end

  describe '#show_bids?' do
    it 'should return true if the auction is closed' do
      auction = create(:auction, :single_bid)
      rules = Rules::SealedBid.new(auction)
      expect(rules.show_bids?).to eq(!AuctionStatus.new(auction).available?)
    end
  end
end
