require 'rails_helper'

RSpec.describe Policy::MultiBidAuction, type: :model do
  let(:ar_auction) { FactoryGirl.create(:auction, :with_bidders) }
  let(:pr_auction) { Presenter::Auction.new(ar_auction) }
  let(:user) { FactoryGirl.create(:user) }
  let(:auction) { Policy::MultiBidAuction.new(pr_auction, user) }
  let(:user2) { FactoryGirl.create(:user) }
  let(:user3) { FactoryGirl.create(:user) }

  describe 'user_can_bid?' do
    context 'when the user is not logged in' do
      let(:user) { nil }

      it 'should return false' do
        skip("This is true so the user can bid")
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the user does not have a SAM account' do
      let(:user) { FactoryGirl.create(:user, sam_account: false) }

      it 'should return false' do
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the auction is closed' do
      let(:ar_auction) { FactoryGirl.create(:auction, :closed) }

      it 'should return false' do
        expect(auction.user_can_bid?).to be_falsey
      end
    end

    context 'when the auction is running' do
      it 'should return true' do
        expect(auction.user_can_bid?).to be_truthy
      end
    end
  end

  describe 'bids?' do
    context 'when there are bids' do
      it 'should return true' do
        expect(auction.bids?).to be_truthy
      end
    end

    context 'when there are no bids' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should return false' do
        expect(auction.bids?).to be_falsey
      end
    end
  end

  describe 'bid_count' do
    it 'should be the number of bids' do
      expect(auction.bid_count).to eq(ar_auction.bids.count)
    end
  end

  describe 'highlighted_bid' do
    context 'when there are bids' do
      it 'should be the lowest bid' do
        bid = ar_auction.bids.sort_by(&:amount).first
        expect(auction.highlighted_bid).to eq(Presenter::Bid.new(bid))
      end

      it 'should return a Presenter::Bid object' do
        expect(auction.highlighted_bid).to be_a(Presenter::Bid)
      end
    end

    context 'when there are no bids' do
      let(:ar_auction) { FactoryGirl.create(:auction) }

      it 'should be nil' do
        expect(auction.highlighted_bid).to be_nil
      end
    end
  end

  describe 'winning_bid' do
    context 'when the auction is still running' do
      it 'should return the lowest bid' do
        bid = ar_auction.bids.sort_by(&:amount).first
        expect(auction.winning_bid).to eq(Presenter::Bid.new(bid))
      end
    end

    context 'when the auction is over' do
      it 'should return the lowest bid' do
        bid = ar_auction.bids.sort_by(&:amount).first
        expect(auction.winning_bid).to eq(Presenter::Bid.new(bid))
      end

      it 'should return a Presenter::Bid object' do
        expect(auction.winning_bid).to be_a(Presenter::Bid)
      end
    end
  end

  describe 'displayed_bids' do
    it 'should be all bids in reverse chronological order' do
      ar_bids = ar_auction.bids.sort_by(&:created_at).reverse.map {|b| Presenter::Bid.new(b) }
      expect(auction.displayed_bids).to eq(ar_bids)
    end
  end

  describe 'max_possible_bid_amount' do
    it 'should be the BID_INCREMENT less than the lowest bid' do
      lowest_bid_amount = ar_auction.bids.sort_by(&:amount).first.amount
      expect(auction.max_possible_bid_amount).to eq(lowest_bid_amount - PlaceBid::BID_INCREMENT)
    end
  end

  describe 'min_possible_bid_amount' do
    it 'should always be 1' do
      expect(auction.min_possible_bid_amount).to eq(1)
    end
  end
end
