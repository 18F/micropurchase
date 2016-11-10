require 'rails_helper'

describe BidStatusPresenterFactory do
  context 'when the winner missed delivery' do
    it 'should return a MissedDelivery status presenter to the winner' do
      auction = create(:auction, :with_bids, :closed, delivery_status: :missed_delivery)
      bidder = WinningBid.new(auction).find.bidder
      presenter = BidStatusPresenterFactory.new(auction: auction, user: bidder).create

      expect(presenter).to be_a(BidStatusPresenter::Over::Vendor::Winner::MissedDelivery)
    end

    it 'should return a general Closed status for other vendors' do
      auction = create(:auction, :with_bids, :closed, delivery_status: :missed_delivery)
      user = create(:user)
      presenter = BidStatusPresenterFactory.new(auction: auction, user: user).create

      expect(presenter).to be_a(BidStatusPresenter::Over::NotBidder)
    end
  end
end
