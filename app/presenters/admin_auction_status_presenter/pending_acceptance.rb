class AdminAuctionStatusPresenter::PendingAcceptance < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.pending_acceptance.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.pending_acceptance.body',
      winner_url: winner_url,
      delivery_url: auction.delivery_url
    )
  end

  def action_partial
    'admin/auctions/accept_or_reject'
  end

  def self.relevant?(status)
    status.pending_acceptance?
  end
end
