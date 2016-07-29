class WinningBidderEmailSender
  def initialize(auction)
    @auction = auction
  end

  def perform
    if auction_has_winner?
      AuctionMailer
        .winning_bidder_notification(bidder: winning_bidder, auction: auction)
        .deliver_later
    end
  end

  private

  attr_reader :auction

  def auction_has_winner?
    WinningBid.new(auction).find.is_a?(Bid)
  end

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end
end
