class BidStatusPresenter::Over::Vendor::Winner::PendingAcceptance < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.pending_acceptance.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.pending_acceptance.body',
      delivery_url: auction.delivery_url
    )
  end
end
