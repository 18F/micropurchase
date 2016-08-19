class BidStatusPresenter::OverUserIsWinnerPendingPayment < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.pending_payment.header')
  end

  def body
    I18n.t(
      'auctions.show.status.pending_payment.body',
      amount: winning_amount,
      delivery_url: auction.delivery_url,
      payment_url: user.payment_url
    )
  end
end
