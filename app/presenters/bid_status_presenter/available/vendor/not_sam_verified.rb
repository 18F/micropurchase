class BidStatusPresenter::Available::Vendor::NotSamVerified < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.vendor.not_verified.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.available.vendor.not_verified.body')
  end
end
