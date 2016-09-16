class AdminAuctionStatusPresenter::ReadyToPublish < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.header')
  end

  def body
    I18n.t('statuses.admin_auction_status_presenter.future.unpublished.body')
  end
end
