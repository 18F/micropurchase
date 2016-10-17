require 'rails_helper'

describe UserAuctionViewModel do
  describe '#bidding_status' do
    it 'should return the auction bidding status' do
      auction = create(:auction, :available)

      expect(UserAuctionViewModel.new(auction, user).bidding_status).to eq('Open')
    end
  end

  describe '#user_bid_count' do
    it 'should return the total number of bids the user has made' do
      user2 = create(:user)
      auction = create(:auction, bidders: [user, user2, user, user2, user])

      expect(UserAuctionViewModel.new(auction, user).user_bid_count).to eq(3)
    end
  end

  describe '#user_won_label' do
    context 'when the auction is not over yet' do
      it 'should return "-"' do
        auction = create(:auction, :available, :with_bids)
        user = WinningBid.new(auction).find.bidder

        expect(UserAuctionViewModel.new(auction, user).user_won_label).to eq('-')
      end
    end

    context 'when the auction is over' do
      it 'should return "Yes" if the user has the winning bid' do
        auction = create(:auction, :closed, :with_bids)
        user = WinningBid.new(auction).find.bidder

        expect(UserAuctionViewModel.new(auction, user).user_won_label).to eq('Yes')
      end

      it 'should return "No" if the user does not have the winning bid' do
        auction = create(:auction, :closed, :with_bids)
        expect(UserAuctionViewModel.new(auction, user).user_won_label).to eq('No')
      end
    end
  end

  def user
    @_user ||= create(:user)
  end
end
