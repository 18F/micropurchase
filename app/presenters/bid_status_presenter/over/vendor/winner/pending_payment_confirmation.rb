class BidStatusPresenter::Over::Vendor::Winner::PendingPaymentConfirmation < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.pending_payment_confirmation.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.pending_payment_confirmation.body',
      payment_date: paid_at
    )
  end

  def action_partial
    'receipts/confirm_payment'
  end

  private

  def paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end
end
