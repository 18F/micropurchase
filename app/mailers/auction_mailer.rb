class AuctionMailer < ActionMailer::Base
  def losing_bidder_notification(bidder:, auction:)
    @auction = auction
    bidder = bidder
    mail(
      to: bidder.email,
      subject: I18n.t('mailers.auction_mailer.losing_bidder_notification.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def winning_bidder_notification(bidder:, auction:)
    @auction = auction
    bidder = bidder
    mail(
      to: bidder.email,
      subject: I18n.t('mailers.auction_mailer.winning_bidder_notification.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end
end
