class BidStatusPresenter::Available::Vendor::NotSmallBusiness < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.available.vendor.not_small_business.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.available.vendor.not_small_business.body')
  end
end
