class BidStatusPresenter::Over::Vendor::Winner::WorkNotStarted < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.work_not_started.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.work_not_started.body',
      ended_at: end_date,
      delivery_deadline: delivery_deadline,
      issue_url: auction.issue_url
    )
  end

  def action_partial
    'auctions/delivery_url'
  end
end
