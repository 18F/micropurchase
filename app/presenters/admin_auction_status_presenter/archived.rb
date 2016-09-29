class AdminAuctionStatusPresenter::Archived < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.archived.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.archived.body'
    )
  end
end
