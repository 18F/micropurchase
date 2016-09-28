class AdminMailer < ActionMailer::Base
  ADMIN_EMAIL_ADDRESS = 'micropurchase@gsa.gov'.freeze

  def vendor_started_work(auction:)
    @auction = auction
    winning_bid = WinningBid.new(@auction).find
    winner = winning_bid.bidder
    @winner_name = winner.name || winner.github_login

    mail(
      to: ADMIN_EMAIL_ADDRESS,
      subject: I18n.t('mailers.admin_mailer.vendor_started_work.subject'),
      from: SMTPCredentials.default_from,
      reply_to: 'micropurchase@gsa.gov'
    )
  end
end
