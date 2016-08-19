class AuctionReceiptViewModel < AuctionShowViewModel
  def bid_status_presenter
    BidStatusPresenter::PaymentConfirmationNeededUserIsWinner.new(
      auction: auction,
      user: current_user
    )
  end
end
