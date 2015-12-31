module AuctionHelper
  def auction_status(auction)
    if auction.available?
      'Open'
    else
      'Closed'
    end
  end

  def auction_label(auction)
    if auction.expiring?
      'Expiring'
    elsif auction.over?
      'Closed'
    elsif auction.future?
      'Coming Soon'
    else
      'Open'
    end
  end
end
