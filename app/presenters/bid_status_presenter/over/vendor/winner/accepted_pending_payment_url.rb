class BidStatusPresenter::Over::Vendor::Winner::AcceptedPendingPaymentUrl < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.accepted_pending_payment_url.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.accepted_pending_payment_url.body',
      delivery_url: auction.delivery_url,
    )
  end
end
