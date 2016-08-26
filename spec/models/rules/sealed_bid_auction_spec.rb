require 'rails_helper'

describe Rules::SealedBidAuction do
  describe '#winning_bid' do
    context 'if the auction if open' do
      it 'returns a NullBid object' do
        auction = create(:auction, :sealed_bid, :with_bids)
        eligibility = InSamEligibility.new
        rules = Rules::SealedBidAuction.new(auction, eligibility)
        expect(rules.winning_bid).to be_a(NullBid)
      end
    end

    context 'if the auction is over' do
      it "returns the auction's lowest bid" do
        auction = create(:auction, :sealed_bid, :with_bids, :closed)
        eligibility = InSamEligibility.new
        rules = Rules::SealedBidAuction.new(auction, eligibility)
        expect(rules.winning_bid).to eq(auction.lowest_bid)
      end
    end
  end

  describe '#veiled_bids' do
    context 'if the auction is open' do
      context 'if the user made a bid' do
        it "should return only the user's bid" do
          auction = create(:auction, :sealed_bid, :with_bids)
          user = auction.bids.first.bidder
          eligibility = InSamEligibility.new
          rules = Rules::SealedBidAuction.new(auction, eligibility)
          expect(rules.veiled_bids(user)).to eq([auction.bids.first])
        end
      end

      context 'if the user did not bid' do
        it 'should return an empty array' do
          auction = create(:auction, :sealed_bid)
          user = create(:user)
          eligibility = InSamEligibility.new
          rules = Rules::SealedBidAuction.new(auction, eligibility)
          expect(rules.veiled_bids(user)).to eq([])
        end
      end
    end

    context 'if the auction is over' do
      it 'should return all bids' do
        user = create(:user)
        auction = create(:auction, :sealed_bid, :with_bids, :closed)
        eligibility = InSamEligibility.new
        rules = Rules::SealedBidAuction.new(auction, eligibility)
        expect(rules.veiled_bids(user)).to eq(auction.bids)
      end
    end
  end

  describe '#user_can_bid?' do
    context 'when the user has placed a bid' do
      it 'should return false' do
        auction = create(:auction, :sealed_bid, :with_bids)
        user = auction.bids.first.bidder
        eligibility = InSamEligibility.new
        rules = Rules::SealedBidAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user has not placed a bid' do
      it 'should return true' do
        auction = create(:auction, :sealed_bid)
        user = create(:user, sam_status: :sam_accepted)
        eligibility = InSamEligibility.new
        rules = Rules::SealedBidAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_truthy
      end
    end
  end

  describe '#max_allowed_bid' do
    it 'should return BID_INCREMENT below the start price' do
      auction = create(:auction, :sealed_bid)
      eligibility = InSamEligibility.new
      rules = Rules::SealedBidAuction.new(auction, eligibility)
      expect(rules.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
    end
  end

  describe '#show_bids?' do
    it 'should return true if the auction is closed' do
      auction = create(:auction, :sealed_bid)
      eligibility = InSamEligibility.new
      rules = Rules::SealedBidAuction.new(auction, eligibility)
      expect(rules.show_bids?).to eq(!AuctionStatus.new(auction).available?)
    end
  end
end
