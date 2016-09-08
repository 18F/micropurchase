class BidStatusPresenter::Over::Admin::PendingAcceptance < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.admin.pending_acceptance.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.admin.pending_acceptance.body',
      winner_url: winner_url,
      delivery_url: auction.delivery_url
    )
  end

  def action_partial
    'admin/auctions/accept_or_reject'
  end

  private

  def winner
    WinningBid.new(auction).find.bidder
  end

  def winner_url
    Url.new(
      link_text: winner.email,
      path_name: 'admin_user',
      params: { id: winner.id }
    )
  end
end
