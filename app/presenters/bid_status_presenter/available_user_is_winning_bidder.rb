class BidStatusPresenter::AvailableUserIsWinningBidder < BidStatusPresenter::Base
  attr_reader :bid_amount

  def initialize(bid_amount:)
    @bid_amount = bid_amount
  end

  def header
    'Bid placed'
  end

  def body
    "You are currently the low bidder, with a bid of #{Currency.new(bid_amount)}"
  end
end
