require 'rails_helper'

describe UserBidsViewModel do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:user3) { create(:user) }
  let(:ar_auction) { create(:auction, :with_bidders, bidder_ids: [user.id, user2.id, user3.id, user2.id, user3.id, user.id]) }
  let(:bids) { ar_auction.bids.sort_by(&:amount).reverse }

  context 'when the user has placed a bid' do
    let(:user_bids) { UserBidsViewModel.new(user, bids) }

    it 'should return only the user bids for bids' do
      expect(user_bids.bids).to be_an(Array)
      expect(user_bids.bids.length).to eq(2)
      user_bids.bids.each do |bid|
        expect(bid).to be_a(::Bid)
        expect(bid.bidder).to eq(user)
      end
    end

    it 'should return the lowest bid' do
      bid = user_bids.lowest_bid
      expect(bid).to be_a(::Bid)
      expect(bid.bidder).to eq(user)
      expect(bid.amount).to eq(bids.last.amount)
    end

    it 'should return the lowest bid amount' do
      expect(user_bids.lowest_bid_amount).to eq(bids.last.amount)
    end
  end

  context 'when the user has not placed a bid' do
    let(:other_user) { create(:user) }
    let(:user_bids) { UserBidsViewModel.new(other_user, bids) }

    it 'should return an empty array for bids' do
      expect(user_bids.bids).to eq([])
    end

    it 'should return nil for the lowest bid' do
      expect(user_bids.lowest_bid).to be_nil
    end

    it 'should return nil for the lowest bid amount' do
      expect(user_bids.lowest_bid_amount).to be_nil
    end
  end

  context 'when the user is nil' do
    let(:user_bids) { UserBidsViewModel::Null.new }

    it 'should return an empty array for bids' do
      expect(user_bids.bids).to eq([])
    end

    it 'should return nil for the lowest bid' do
      expect(user_bids.lowest_bid).to be_nil
    end

    it 'should return nil for the lowest bid amount' do
      expect(user_bids.lowest_bid_amount).to be_nil
    end
  end
end
