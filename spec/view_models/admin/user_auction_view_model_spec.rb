require 'rails_helper'

describe Admin::UserAuctionViewModel do
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

  describe '#accepted_label' do
    context 'when the user is the winning_bidder' do
      it 'returns "Yes" when the auction was accepted' do
        auction = create(:auction, :closed, :with_bids, :accepted)
        bidder = WinningBid.new(auction).find.bidder
        expect(Admin::UserAuctionViewModel.new(auction, bidder).accepted_label).to eq('Yes')
      end

      it 'returns "No" when auction was not accepted yet' do
        auction = create(:auction, :closed, :rejected, :with_bids)
        bidder = WinningBid.new(auction).find.bidder
        expect(Admin::UserAuctionViewModel.new(auction, bidder).accepted_label).to eq('No')
      end
    end

    context 'when the user is not the winning bidder' do
      it 'returns "-"' do
        auction = create(:auction, :closed, :with_bids, accepted_at: Time.now)
        expect(Admin::UserAuctionViewModel.new(auction, user).accepted_label).to eq('-')
      end
    end
  end

  def user
    @_user ||= create(:user)
  end
end
