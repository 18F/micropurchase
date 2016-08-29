class BidStatusPresenter::Over::Vendor::Winner::WorkInProgress < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.work_in_progress.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.work_in_progress.body',
      ended_at: end_date,
      delivery_deadline: delivery_deadline,
      delivery_url: auction.delivery_url
    )
  end

  def action_partial
    'auctions/work_in_progress'
  end
end
