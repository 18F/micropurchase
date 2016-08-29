class BidStatusPresenter::Available::Vendor::ReverseAuctionOutbid < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.vendor.reverse_auction_outbid.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.available.vendor.reverse_auction_outbid.body',
      max_allowed_bid_as_currency: max_allowed_bid_as_currency
    )
  end

  def action_partial
    'auctions/bid_form'
  end
end
