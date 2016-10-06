class C2StatusPresenter::C2Paid < C2StatusPresenter::Base
  def body
    I18n.t(
      'statuses.c2_presenter.c2_paid.body',
      winner_url: winner_url,
      paid_at: DcTimePresenter.convert_and_format(auction.paid_at)
    )
  end

  def header
    I18n.t('statuses.c2_presenter.c2_paid.header')
  end
end
