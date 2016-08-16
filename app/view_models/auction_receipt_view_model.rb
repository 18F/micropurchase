class AuctionReceiptViewModel < AuctionShowViewModel
  def bid_status
    BidStatusPresenter::PaymentConfirmationNeededUserIsWinner.new(
      auction: auction,
      user: current_user
    )
  end
end
