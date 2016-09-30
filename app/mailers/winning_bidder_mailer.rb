class WinningBidderMailer < ActionMailer::Base
  def auction_ended(bidder:, auction:)
    @auction = auction
    bidder = bidder
    mail(
      to: bidder.email,
      subject: I18n.t('mailers.winning_bidder_mailer.auction_ended.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def auction_accepted(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t('mailers.winning_bidder_mailer.auction_accepted.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def auction_accepted_missing_payment_method(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t('mailers.winning_bidder_mailer.auction_accepted_missing_payment_method.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def auction_rejected(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find
    @rejected_timestamp = auction.rejected_at || Time.current

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t('mailers.winning_bidder_mailer.auction_rejected.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def auction_paid_default_pcard(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t(
        'mailers.auction_mailer.auction_paid_default_pcard.subject',
        auction_title: @auction.title
      ),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end

  def auction_paid_other_pcard(auction:)
    @auction = auction
    @winning_bid = WinningBid.new(@auction).find

    mail(
      to: @winning_bid.bidder.email,
      subject: I18n.t(
        'mailers.auction_mailer.auction_paid_other_pcard.subject',
        auction_title: @auction.title
      ),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end
end
