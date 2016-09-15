class BidStatusPresenter::Over::Vendor::Winner::Accepted < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.winner.accepted.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.winner.accepted.body',
      amount: winning_amount,
      delivery_url: auction.delivery_url,
      payment_url: user.payment_url
    )
  end
end
