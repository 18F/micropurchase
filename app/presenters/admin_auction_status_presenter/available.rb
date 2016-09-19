class AdminAuctionStatusPresenter::Available < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.admin.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.available.admin.body', end_date: end_date)
  end
end
