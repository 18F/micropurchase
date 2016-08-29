class BidStatusPresenter::Over::Vendor::Bidder < BidStatusPresenter::Base
  def header
    I18n.t('statuses.bid_status_presenter.over.bidder.header')
  end

  def body
    I18n.t(
      'statuses.bid_status_presenter.over.bidder.body',
      bid_amount: bid_amount,
      end_date: end_date
    )
  end

  private

  def bid_amount
    Currency.new(auction.bids.where(bidder: user).last.amount)
  end
end
