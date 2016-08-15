class BidStatusPresenter::AvailableUserNotSamVerified < BidStatusPresenter::Base
  def header
    I18n.t('auctions.show.status.open.vendor.not_verified.header')
  end

  def body
    I18n.t('auctions.show.status.open.vendor.not_verified.body')
  end
end
