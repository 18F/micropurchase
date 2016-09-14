class AdminAuctionStatusPresenter::PendingPaymentUrl < AdminAuctionStatusPresenter::Base
  def header
    I18n.t('statuses.admin_auction_status_presenter.pending_payment_url.header')
  end

  def body
    I18n.t(
      'statuses.admin_auction_status_presenter.pending_payment_url.body',
      winner_url: winner_url,
      delivery_url: auction.delivery_url
    )
  end
end
