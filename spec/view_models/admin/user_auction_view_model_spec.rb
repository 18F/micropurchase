require 'rails_helper'

describe Admin::UserAuctionViewModel do
  describe '#status' do
    it 'should return the auction status' do
      auction = create(:auction, :available)

      expect(Admin::UserAuctionViewModel.new(auction, user).status).to eq('Open')
    end
  end

  describe '#skills' do
    it 'should return a mm/dd/yy date in EST' do
      auction = create(:auction)
      skills = [create(:skill, name: 'sewing'), create(:skill, name: 'eating')]
      auction.skills << skills

      expect(Admin::UserAuctionViewModel.new(auction, user).skills).to eq(
        'eating, sewing'
      )
    end
  end

  describe '#user_bid_count' do
    it 'should return the total number of bids the user has made' do
      user2 = create(:user)
      auction = create(:auction, :with_bidders, bidder_ids: [user.id, user2.id, user.id, user2.id, user.id])

      expect(Admin::UserAuctionViewModel.new(auction, user).user_bid_count).to eq(3)
    end
  end

  describe '#user_won_label' do
    context 'when the auction is not over yet' do
      it 'should return "-"' do
        auction = create(:auction, :available, :with_bidders)
        user = WinningBid.new(auction).find.bidder

        expect(Admin::UserAuctionViewModel.new(auction, user).user_won_label).to eq('-')
      end
    end

    context 'when the auction is over' do
      it 'should return "Yes" if the user has the winning bid' do
        auction = create(:auction, :closed, :with_bidders)
        user = WinningBid.new(auction).find.bidder

        expect(Admin::UserAuctionViewModel.new(auction, user).user_won_label).to eq('Yes')
      end

      it 'should return "No" if the user does not have the winning bid' do
        auction = create(:auction, :closed, :with_bidders)
        expect(Admin::UserAuctionViewModel.new(auction, user).user_won_label).to eq('No')
      end
    end
  end

  describe '#accepted_label' do
    context 'when the user is the winning_bidder' do
      it 'returns "Yes" when the auction was accepted' do
        auction = create(:auction, :closed, :with_bidders, :accepted)
        bidder = WinningBid.new(auction).find.bidder
        expect(Admin::UserAuctionViewModel.new(auction, bidder).accepted_label).to eq('Yes')
      end

      it 'returns "No" when auction was not accepted yet' do
        auction = create(:auction, :closed, :rejected, :with_bidders)
        bidder = WinningBid.new(auction).find.bidder
        expect(Admin::UserAuctionViewModel.new(auction, bidder).accepted_label).to eq('No')
      end
    end

    context 'when the user is not the winning bidder' do
      it 'returns "-"' do
        auction = create(:auction, :closed, :with_bidders, accepted_at: Time.now)
        expect(Admin::UserAuctionViewModel.new(auction, user).accepted_label).to eq('-')
      end
    end
  end

  def user
    @_user ||= create(:user)
  end
end
