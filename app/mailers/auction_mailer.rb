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

  def auction_accepted_customer_notification(auction:)
    @auction = auction
    customer = auction.customer
    @winning_bid = WinningBid.new(auction).find
    mail(
      to: customer.email,
      subject: I18n.t('mailers.auction_mailer.auction_accepted_customer_notification.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def winning_bidder_missing_payment_method(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t('mailers.auction_mailer.winning_bidder_missing_payment_method.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end
end
