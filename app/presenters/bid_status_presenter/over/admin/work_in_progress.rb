class BidStatusPresenter::Over::Admin::WorkInProgress < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.admin.work_in_progress.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.admin.work_in_progress.body',
      winner_url: winner_url,
      delivery_url: auction.delivery_url,
      delivery_deadline: delivery_deadline
    )
  end

  private

  def winner_url
    Url.new(
      link_text: winner.email,
      path_name: 'admin_user',
      params: { id: winner.id }
    )
  end

  def winner
    WinningBid.new(auction).find.bidder
  end

  def delivery_deadline
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end
end
