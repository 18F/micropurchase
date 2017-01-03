class AdminAuctionStatusPresenter::MissedDelivery < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.missed_delivery.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.missed_delivery.body'
    )
  end

  def self.relevant?(status)
    status.missed_delivery?
  end
end
