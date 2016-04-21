require 'rails_helper'

describe AuctionMailer do
  describe '#losing_bidder_notification' do
    it 'sends the email to the bidder' do
      bidder = create(:user, email: "test@example.com")
      bid = create(:bid, bidder: bidder)
      email = AuctionMailer.losing_bidder_notification(bid)

      expect(email.to).to eq [bidder.email]
      expect(email.subject).to eq(
        I18n.t('mailers.auction_mailer.losing_bidder_notification.subject')
      )
      expect(email.subject).to eq I18n.t('mailers.auction_mailer.losing_bidder_notification.subject')
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
end
