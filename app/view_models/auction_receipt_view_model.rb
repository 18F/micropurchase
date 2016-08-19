class AuctionReceiptViewModel < AuctionShowViewModel
  def bid_status_presenter
    BidStatusPresenter::Over::Vendor::Winner::PendingPaymentConfirmation.new(
      auction: auction,
      user: current_user
    )
  end
end
