require 'rails_helper'

describe MarkAuctionDeliveryMissed do
  describe '#perform' do
    it 'sets the auction delivery_status to missed_delivery' do
      auction = create(:auction, :with_bids, :work_in_progress)

      MarkAuctionDeliveryMissed.new(auction: auction).perform

      expect(auction).to be_missed_delivery
    end

    it 'sends an email to the vendor notifying them they missed the deadline' do
      auction = create(:auction, :with_bids, :work_in_progress)

      mailer_double = double(deliver_later: true)
      allow(WinningBidderMailer).to receive(:auction_not_delivered)
        .with(auction: auction)
        .and_return(mailer_double)

      MarkAuctionDeliveryMissed.new(auction: auction).perform

      expect(WinningBidderMailer).to have_received(:auction_not_delivered)
      expect(mailer_double).to have_received(:deliver_later)
    end
  end
end
