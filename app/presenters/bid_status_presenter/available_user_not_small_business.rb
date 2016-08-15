class BidStatusPresenter::AvailableUserNotSmallBusiness < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.open.vendor.not_small_business.header')
  end

  def body
    I18n.t('auctions.show.status.open.vendor.not_small_business.body')
  end
end
