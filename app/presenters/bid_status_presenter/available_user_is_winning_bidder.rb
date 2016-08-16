class BidStatusPresenter::AvailableUserIsWinningBidder < BidStatusPresenter::Base
  def header
    'Bid placed'
  end

  def body
    "You are currently the low bidder, with a bid of #{Currency.new(bid_amount)}"
  end

  private

  def bid_amount
    lowest_user_bid.try(:amount)
  end

  def lowest_user_bid
    user_bids.order(amount: :asc).first
  end

  def user_bids
    @_user_bids ||= auction.bids.where(bidder: user)
  end
end
