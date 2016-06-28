require 'rails_helper'

describe AuctionEnded do
  describe '#perform' do
    context 'an auction ends' do
      it 'sends the winning bidder email' do
        auction = create(:auction)

        winning_bidder_email_sender_double = instance_double("WinningBidderEmailSender")
        allow(winning_bidder_email_sender_double).to receive(:perform)
        allow(WinningBidderEmailSender).to receive(:new)
          .with(any_args)
          .and_return(winning_bidder_email_sender_double)

        expect(winning_bidder_email_sender_double).to receive(:perform)

        AuctionEnded.new(auction).perform
      end

      it 'sends the losing bidders email' do
        auction = create(:auction)

        auction = create(:auction, :closed, :with_bidders)

        losing_bidder_email_sender_double = instance_double("LosingBidderEmailSender")
        allow(losing_bidder_email_sender_double).to receive(:perform)
        allow(LosingBidderEmailSender).to receive(:new)
          .with(any_args)
          .and_return(losing_bidder_email_sender_double)

        expect(losing_bidder_email_sender_double).to receive(:perform)

        AuctionEnded.new(auction).perform
      end
    end
  end
end
