require 'rails_helper'

describe WinningBidderMailer do
  describe '#auction_accepted_notification' do
    it 'sends the email to the winning bidder' do
      auction = create(:auction, :with_bids, :closed)
      winning_bid = WinningBid.new(auction).find
      winning_bidder = winning_bid.bidder

      email = WinningBidderMailer.auction_accepted(auction: auction)

      expect(email.to).to eq [winning_bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.winning_bidder_mailer.auction_accepted.subject')
      )
    end
  end

  describe 'auction_accepted_missing_payment_method' do
    it 'sends the email to the winning bidder' do
      auction = create(:auction, :with_bids, :closed)
      winning_bid = WinningBid.new(auction).find
      winning_bidder = winning_bid.bidder

      email = WinningBidderMailer.auction_accepted_missing_payment_method(
        auction: auction
      )

      expect(email.to).to eq [winning_bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.winning_bidder_mailer.auction_accepted_missing_payment_method.subject')
      )
    end
  end
end
