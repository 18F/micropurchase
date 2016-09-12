class BidStatusPresenter::Available::Vendor::BidError < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.vendor.bid_error.header')
  end

  def body
    bid_error
  end

  def alert_css_class
    'usa-alert-error'
  end

  def action_partial
    'auctions/bid_form'
  end
end
