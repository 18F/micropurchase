require 'rails_helper'

describe WinningBidderEmailSender do
  describe '#perform' do
    context 'the winning bidder has an email address' do
      it 'emails the winning bidder' do
        auction = create(:auction, :closed, :with_bids)
        winning_bid = WinningBid.new(auction).find
        winning_bidder = winning_bid.bidder

        mailer_double = double(deliver_later: true)
        allow(WinningBidderMailer).to receive(:auction_ended)
          .with(bidder: winning_bidder, auction: auction)
          .and_return(mailer_double)

        WinningBidderEmailSender.new(auction).perform

        expect(WinningBidderMailer).to have_received(:auction_ended)
          .with(bidder: winning_bidder, auction: auction)
      end
    end
  end
end
