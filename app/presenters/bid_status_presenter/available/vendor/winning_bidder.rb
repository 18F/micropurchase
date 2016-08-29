class BidStatusPresenter::Available::Vendor::WinningBidder < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.vendor.winning_bidder.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.available.vendor.winning_bidder.body',
      winning_amount: winning_amount
    )
  end
end
