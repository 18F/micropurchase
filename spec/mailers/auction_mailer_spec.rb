require 'rails_helper'

describe AuctionMailer do
  describe '#winning_bidder_notification' do
    it 'sends the email to the winning bidder' do
      auction = create(:auction, :with_bidders, :closed)
      winning_bid = WinningBid.new(auction).find
      winning_bidder = winning_bid.bidder

      email = AuctionMailer.winning_bidder_notification(bidder: winning_bidder, auction: auction)

      expect(email.to).to eq [winning_bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.auction_mailer.winning_bidder_notification.subject')
      )

      expect(email.from).to eq [SMTPCredentials.default_from]
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.auction_mailer.winning_bidder_notification.para_1',
          auction_title: auction.title,
          auction_url: auction_url(auction),
          bid_amount: Currency.new(WinningBid.new(auction).find.amount).to_s,
          auction_delivery_deadline: DcTimePresenter.convert_and_format(auction.delivery_due_at),
          auction_issue_url: auction.issue_url
        )
      )
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.auction_mailer.winning_bidder_notification.para_2',
          auction_url: auction_url(@auction)
        )
      )
      expect(email.body.encoded).to include(
        I18n.t('mailers.auction_mailer.winning_bidder_notification.sign_off')
      )
    end
  end

  describe '#losing_bidder_notification' do
    it 'sends the email to the losing bidder' do
      bidder = create(:user, email: "test@example.com")
      bid = create(:bid, bidder: bidder)
      email = AuctionMailer
              .losing_bidder_notification(bidder: bidder, auction: bid.auction)

      expect(email.to).to eq [bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.auction_mailer.losing_bidder_notification.subject')
      )
      expect(email.from).to eq [SMTPCredentials.default_from]
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.auction_mailer.losing_bidder_notification.para_1',
          auction_title: bid.auction.title,
          auction_url: auction_url(bid.auction)
        )
      )
      expect(email.body.encoded).to include(
        I18n.t('mailers.auction_mailer.losing_bidder_notification.para_2')
      )
      expect(email.body.encoded).to include(
        I18n.t('mailers.auction_mailer.losing_bidder_notification.sign_off')
      )
    end
  end

  describe '#auction_accepted_customer_notification' do
    it 'sends the email to the customer' do
      customer = create(:customer, email: 'test@example.com')
      auction = create(:auction, customer: customer)
      amount = 123
      bid = create(:bid, auction: auction, amount: amount)

      email = AuctionMailer.auction_accepted_customer_notification(auction: auction)

      expect(email.to).to eq [customer.email]
      expect(email.subject).to eq(
        I18n.t('mailers.auction_mailer.auction_accepted_customer_notification.subject')
      )
      expect(email.from).to eq [SMTPCredentials.default_from]
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.auction_mailer.auction_accepted_customer_notification.para_1',
          auction_title: auction.title,
          vendor_name: bid.bidder_name,
          winning_bid_amount: Currency.new(amount).to_s
        )
      )
      expect(email.body.encoded).to include(
        I18n.t(
          'mailers.auction_mailer.auction_accepted_customer_notification.para_2',
          delivery_url: auction.delivery_url
        )
      )
      expect(email.body.encoded).to include(
        I18n.t('mailers.auction_mailer.losing_bidder_notification.sign_off')
      )
    end
  end
end
