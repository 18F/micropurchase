module AuctionHelper
  def auction_status(auction)
    if auction.available?
      'Open'
    else
      'Closed'
    end
  end
end
