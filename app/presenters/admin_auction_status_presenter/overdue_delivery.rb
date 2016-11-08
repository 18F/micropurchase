class AdminAuctionStatusPresenter::OverdueDelivery < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.overdue_delivery.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.overdue_delivery.body',
      winner_url: winner_url
    )
  end

  def action_partial
    'admin/auctions/overdue_delivery'
  end
end
