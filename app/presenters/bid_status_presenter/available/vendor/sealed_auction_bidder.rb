class BidStatusPresenter::Available::Vendor::SealedAuctionBidder < BidStatusPresenter::Base
  def header
    ''
  end

  def body
    "You bid #{Currency.new(bid.amount)} on #{DcTimePresenter.convert_and_format(bid.created_at)}."
  end

  private

  def bid
    user_bids.order(amount: :asc).first
  end

  def user_bids
    @_user_bids ||= auction.bids.where(bidder: user)
  end
end
