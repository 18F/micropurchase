class BidStatusPresenter::FutureUserIsVendor < BidStatusPresenter::Base
  def header
    I18n.t('auctions.status.future.vendor.header')
  end

  def body
    I18n.t('auctions.status.future.vendor.body', start_date: start_date)
  end
end
