class BidStatusPresenter::Available::Vendor::Eligible < BidStatusPresenter::Base
  def body
    I18n.t(
      'statuses.bid_status_presenter.available.vendor.eligible.body',
      max_allowed_bid_as_currency: max_allowed_bid_as_currency
    )
  end

  def action_partial
    'auctions/bid_form'
  end
end
