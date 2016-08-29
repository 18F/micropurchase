class BidStatusPresenter::Future::Vendor < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.future.vendor.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.future.vendor.body', start_date: start_date)
  end
end
