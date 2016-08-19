class BidStatusPresenter::Over::Vendor::Winner::PendingAcceptance < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.pending_acceptance.header')
  end

  def body
    I18n.t(
      'auctions.show.status.pending_acceptance.body',
      delivery_url: auction.delivery_url
    )
  end
end
