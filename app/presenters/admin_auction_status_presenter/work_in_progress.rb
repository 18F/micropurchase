class AdminAuctionStatusPresenter::WorkInProgress < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.work_in_progress.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.work_in_progress.body',
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

  def delivery_deadline
    DcTimePresenter.convert_and_format(auction.delivery_due_at)
  end
end
