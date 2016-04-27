require 'rails_helper'

RSpec.describe Rules::Basic, type: :model do
  let(:ar_auction) { FactoryGirl.create(:auction, :closed, :with_bidders) }
  let(:auction) { Presenter::Auction.new(ar_auction) }

  subject { Rules::Basic.new(auction) }
  
  describe 'winning_bid' do
    it "should be the auction's lowest_bid" do
      expect(subject.winning_bid).to eq(auction.lowest_bid)
    end
  end

  describe 'user_can_bid?' do
    let(:user) { FactoryGirl.create(:user, sam_status: :sam_accepted) }

    context 'when the auction is open and the user can bid' do
      let(:ar_auction) { FactoryGirl.create(:auction) }
      specify { expect(subject.user_can_bid?(user)).to be_truthy }
    end
    
    context 'when the auction is over' do
      specify { expect(subject.user_can_bid?(user)).to be_falsey }
    end

    context 'when the user is nil' do
      specify { expect(subject.user_can_bid?(nil)).to be_falsey }
    end

    context 'when the user is not sam_accepted?' do
      let(:user) { FactoryGirl.create(:user, sam_status: :sam_pending) }
      specify { expect(subject.user_can_bid?(user)).to be_falsey }
    end
  end

  describe 'max_allowed_bid' do
    context 'when there are no bids' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should be BID_INCRMENT below the start price' do
        expect(subject.max_allowed_bid).to eq(auction.start_price - PlaceBid::BID_INCREMENT)
      end
    end

    context 'when there is a bid' do
      let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }
      it 'should be BID_INCREMENT below the lowest bid' do
        expect(subject.max_allowed_bid).to eq(auction.lowest_bid_amount - PlaceBid::BID_INCREMENT)
      end
    end
  end

  describe 'highlighted_bid' do
    let(:user) { FactoryGirl.create(:user) }
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
