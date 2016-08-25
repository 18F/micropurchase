class AdminAuctionStatusPresenter::PendingAcceptance < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.c2_presenter.pending_acceptance.header')
  end

  def body
    I18n.t(
      'statuses.c2_presenter.pending_acceptance.body',
      winner_url: winner_url,
      delivery_url: auction.delivery_url
    )
  end

  def action_partial
    'admin/auctions/accept_or_reject'
  end

  private

  def winner_url
    Url.new(
      link_text: winner.email,
      path_name: 'admin_user',
      params: { id: winner.id }
    )
  end
end
