class BidStatusPresenter::Over::NotBidder < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.not_bidder.header')
  end

  def body
    I18n.t('statuses.bid_status_presenter.over.not_bidder.body', end_date: end_date)
  end
end
