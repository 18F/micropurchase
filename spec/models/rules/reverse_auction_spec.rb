require 'rails_helper'

describe Rules::ReverseAuction do
  describe '#winning_bid' do
    it "should be the auction's lowest_bid" do
      auction = create(:auction, :closed, :with_bids)
      rules = Rules::ReverseAuction.new(auction, eligibility)
      expect(rules.winning_bid).to eq(auction.lowest_bid)
    end
  end

  describe '#user_can_bid?' do
    context 'when the auction is open and the user is eligible to bid' do
      it 'is true' do
        auction = create(:auction)
        user = create(:user, sam_status: :sam_accepted)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_truthy
      end
    end

    context 'when the auction is open and the user is the winner' do
      it 'is false' do
        auction = create(:auction)
        user = create(:user, sam_status: :sam_accepted)
        create(:bid, auction: auction, bidder: user)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to eq(false)
      end
    end

    context 'when the auction is over' do
      it 'is false' do
        auction = create(:auction, :closed)
        user = create(:user, sam_status: :sam_accepted)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user is nil' do
      it 'is false' do
        auction = create(:auction)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(nil)).to be_falsey
      end
    end

    context 'when the user is not sam_accepted?' do
      it 'is false' do
        user = create(:user, sam_status: :sam_pending)
        eligibility = Eligibilities::InSam.new
        auction = create(:auction)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.user_can_bid?(user)).to be_falsey
      end
    end
  end

  describe '#max_allowed_bid' do
    context 'when there are no bids' do
      it 'should be BID_INCRMENT below the start price' do
        auction = create(:auction)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
      end
    end

    context 'when there is a bid' do
      it 'should be BID_INCREMENT below the lowest bid' do
        auction = create(:auction, :with_bids)
        rules = Rules::ReverseAuction.new(auction, eligibility)
        expect(rules.max_allowed_bid).to eq(auction.lowest_bid.amount - PlaceBid::BID_INCREMENT)
      end
    end
  end

  describe '#show_bids?' do
    it 'should always be true' do
      auction = create(:auction, :with_bids)
      rules = Rules::ReverseAuction.new(auction, eligibility)
      expect(rules.show_bids?).to be_truthy
    end
  end

  def eligibility
    @eligibility ||= double(label: '', eligible?: true)
  end
end
