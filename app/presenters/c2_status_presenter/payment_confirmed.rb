class C2StatusPresenter::PaymentConfirmed < C2StatusPresenter::Base
  def body
    I18n.t(
      'statuses.c2_presenter.payment_confirmed.body',
      winner_url: winner_url,
      accepted_date: accepted_date,
      amount: amount,
      paid_at: paid_at
    )
  end

  def header
    I18n.t('statuses.c2_presenter.payment_confirmed.header')
  end

  private

  def paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end

  def accepted_date
    DcTimePresenter.convert_and_format(auction.accepted_at)
  end

  def amount
    Currency.new(winning_bid.amount)
  end
end
