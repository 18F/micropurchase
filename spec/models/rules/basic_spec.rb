require 'rails_helper'

describe Rules::Basic do
  let(:auction) { create(:auction, :closed, :with_bidders) }

  subject { Rules::Basic.new(auction) }

  describe 'winning_bid' do
    it "should be the auction's lowest_bid" do
      expect(subject.winning_bid).to eq(auction.lowest_bid)
    end
  end

  describe 'user_can_bid?' do
    context 'when the auction is open and the user can bid' do
      it 'is true' do
        user = create(:user, sam_status: :sam_accepted)
        auction = create(:auction, :available)
        rules = Rules::Basic.new(auction)
        expect(rules.user_can_bid?(user)).to be_truthy
      end
    end

    context 'when the auction is over' do
      it 'is false' do
      user = create(:user, sam_status: :sam_accepted)
      auction = create(:auction, :closed)
      rules = Rules::Basic.new(auction)
      expect(rules.user_can_bid?(user)).to be_falsey
      end
    end

    context 'when the user is nil' do
      specify { expect(subject.user_can_bid?(nil)).to be_falsey }
    end

    context 'when the user is not sam_accepted?' do
      let(:user) { create(:user, sam_status: :sam_pending) }
      specify { expect(subject.user_can_bid?(user)).to be_falsey }
    end
  end

  describe 'max_allowed_bid' do
    context 'when there are no bids' do
      it 'should be BID_INCREMENT below the start price' do
        auction = create(:auction)
        rules = Rules::Basic.new(auction)
        expect(rules.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
      end
    end

    context 'when there is a bid' do
      let(:ar_auction) { create(:auction, :with_bidders) }
      it 'should be BID_INCREMENT below the lowest bid' do
        expect(subject.max_allowed_bid).to eq(auction.lowest_bid_amount - PlaceBid::BID_INCREMENT)
      end
    end
  end

  describe 'highlighted_bid' do
    let(:user) { create(:user) }
    it 'should return the lowest bid' do
      expect(subject.highlighted_bid(user)).to eq(auction.lowest_bid)
    end
  end

  describe 'show_bids?' do
    it 'should always be true' do
      expect(subject.show_bids?).to be_truthy
    end
  end
end
