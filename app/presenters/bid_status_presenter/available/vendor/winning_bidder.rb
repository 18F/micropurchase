class BidStatusPresenter::Available::Vendor::WinningBidder < BidStatusPresenter::Base
  def header
    'Bid placed'
  end

  def body
    "You are currently the low bidder, with a bid of #{winning_amount}"
  end
end
