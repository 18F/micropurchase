require 'rails_helper'

describe WinningBidderMailer do
  describe '#auction_ended' do
    it 'sends the email to the winning bidder' do
      auction = create(:auction, :with_bids, :closed)
      winning_bid = WinningBid.new(auction).find
      winning_bidder = winning_bid.bidder

      email = WinningBidderMailer.auction_ended(bidder: winning_bidder, auction: auction)

      expect(email.to).to eq [winning_bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.winning_bidder_mailer.auction_ended.subject')
      )

      expect(email.from).to eq [Credentials.smtp_default_from]
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.winning_bidder_mailer.auction_ended.para_1',
          auction_title: auction.title,
          auction_url: auction_url(auction),
          bid_amount: Currency.new(WinningBid.new(auction).find.amount).to_s,
          auction_delivery_deadline: DcTimePresenter.convert_and_format(auction.delivery_due_at),
          auction_issue_url: auction.issue_url
        )
      )
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.winning_bidder_mailer.auction_ended.para_2',
          auction_url: auction_url(auction)
        )
      )
      expect(email.body.encoded).to include(
        I18n.t('mailers.winning_bidder_mailer.auction_ended.sign_off')
      )
    end
  end

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
