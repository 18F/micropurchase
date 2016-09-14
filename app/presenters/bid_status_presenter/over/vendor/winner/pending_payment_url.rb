class BidStatusPresenter::Over::Vendor::Winner::PendingPaymentUrl < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.pending_payment_url.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.pending_payment_url.body',
      delivery_url: auction.delivery_url,
    )
  end
end
