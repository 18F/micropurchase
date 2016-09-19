class AdminAuctionStatusPresenter::Future < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.future.published.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.future.published.body',
      start_date: start_date
    )
  end

  def action_partial
    'admin/auctions/unpublish'
  end

  private

  def start_date
    DcTimePresenter.convert_and_format(auction.started_at)
  end
end
