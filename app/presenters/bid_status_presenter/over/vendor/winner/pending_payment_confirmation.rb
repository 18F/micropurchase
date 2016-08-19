class BidStatusPresenter::Over::Vendor::Winner::PendingPaymentConfirmation < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.payment_confirmation_needed.header')
  end

  def body
    I18n.t('auctions.show.status.payment_confirmation_needed.body', payment_date: paid_at)
  end

  def action_partial
    'receipts/confirm_payment'
  end

  private

  def paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end
end
