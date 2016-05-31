require 'rails_helper'

describe Rules::Basic do
  describe '#winning_bid' do
    it "should be the auction's lowest_bid" do
      auction = create(:auction, :closed, :with_bidders)
      eligibility = InSamEligibility.new
      rules = Rules::Basic.new(auction, eligibility)
      expect(rules.winning_bid).to eq(auction.lowest_bid)
    end
  end

  describe '#user_can_bid?' do
    context 'when the auction is open and the user can bid' do
      it 'is true' do
        auction = create(:auction)
        user = create(:user, sam_status: :sam_accepted)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_truthy
      end
    end

    context 'when the auction is over' do
      it 'is false' do
        auction = create(:auction, :closed)
        user = create(:user, sam_status: :sam_accepted)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user is nil' do
      it 'is false' do
        auction = create(:auction)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.user_can_bid?(nil)).to be_falsey
      end
    end

    context 'when the user is not sam_accepted?' do
      it 'is false' do
        user = create(:user, sam_status: :sam_pending)
        auction = create(:auction)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end
  end

  describe '#max_allowed_bid' do
    context 'when there are no bids' do
      it 'should be BID_INCRMENT below the start price' do
        auction = create(:auction)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
      end
    end

    context 'when there is a bid' do
      it 'should be BID_INCREMENT below the lowest bid' do
        auction = create(:auction, :with_bidders)
        eligibility = InSamEligibility.new
        rules = Rules::Basic.new(auction, eligibility)
        expect(rules.max_allowed_bid).to eq(auction.lowest_bid.amount - PlaceBid::BID_INCREMENT)
      end
    end
  end

  describe '#show_bids?' do
    it 'should always be true' do
      auction = create(:auction, :with_bidders)
      eligibility = InSamEligibility.new
      rules = Rules::Basic.new(auction, eligibility)
      expect(rules.show_bids?).to be_truthy
    end
  end
end
