require 'rails_helper'

describe Admin::OpenListItem do
  describe 'bid_count' do
    it 'should return the total number of bids when the auction has bids' do
      auction = create(:auction, :with_bids)
      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.bid_count).to eq(auction.bids.count)
    end

    it 'should return N/A when the auction has no bids' do
      auction = create(:auction)
      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.bid_count).to eq('N/A')
    end
  end

  describe 'lowest_bid_amount' do
    it 'should return the lowest bid when there is one' do
      auction = create(:auction, :sealed_bid, :with_bids)
      bid = auction.bids.last
      view_model = Admin::OpenListItem.new(auction)

      expect(view_model.lowest_bid_amount).to eq(Currency.new(bid.amount).to_s)
    end

    it 'should return N/A when the auction has no bids' do
      auction = create(:auction, :sealed_bid)
      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.lowest_bid_amount).to eq('N/A')
    end
  end

  describe 'current_winner' do
    it 'should return a name when the user has a name' do
      auction = create(:auction, :sealed_bid, :with_bids)
      bid = auction.bids.last
      user = bid.bidder

      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.current_winner).to eq(user.name)
    end

    it 'should return a github_login when the user has no name' do
      auction = create(:auction, :sealed_bid, :with_bids)
      bid = auction.bids.last
      user = bid.bidder
      user.update_attribute(:name, '')

      auction = Auction.find(auction.id)

      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.current_winner).to eq(user.github_login)
    end

    it 'should return N/A if there are no bids' do
      auction = create(:auction, :sealed_bid)
      bid = auction.bids.last

      view_model = Admin::OpenListItem.new(auction)
      expect(view_model.current_winner).to eq('N/A')
    end
  end
end
