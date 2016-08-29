class BidStatusPresenter::Available::Admin < BidStatusPresenter::Base
  def body
    I18n.t('statuses.bid_status_presenter.available.admin.body', end_date: end_date)
  end
end
