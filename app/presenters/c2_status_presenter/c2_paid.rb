class C2StatusPresenter::C2Paid < C2StatusPresenter::Base
  def status
    I18n.t('statuses.c2_presenter.c2_paid.status')
  end

  def body
    I18n.t(
      'statuses.c2_presenter.c2_paid.body',
      winner_email: winner.email,
      paid_at: DcTimePresenter.convert_and_format(auction.paid_at)
    )
  end

  def header
    I18n.t('statuses.c2_presenter.c2_paid.header')
  end

  private

  def winner
    WinningBid.new(auction).find.bidder
  end
end
