class BidStatusPresenter::Future::Admin < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.future.admin.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.future.admin.body',
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
