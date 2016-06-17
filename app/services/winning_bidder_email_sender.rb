class WinningBidderEmailSender
  def initialize(auction)
    @auction = auction
  end

  def perform
    AuctionMailer
      .winning_bidder_notification(bidder: winning_bidder, auction: auction)
      .deliver_later
  end

  private

  attr_reader :auction

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end
end
