class AuctionMailer < ActionMailer::Base
  def losing_bidder_notification(bid)
    @auction = bid.auction
    bidder = bid.bidder
    mail(
      to: bidder.email,
      subject: I18n.t('mailers.auction_mailer.losing_bidder_notification.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end
end
