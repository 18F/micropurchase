module AuctionHelper
  def auction_status(auction)
    if auction.available?
      'Open'
    else
      'Closed'
    end
  end

  def auction_label_class(auction)
    if auction.expiring?
      'auction-label-expiring'
    elsif auction.over?
      'auction-label-over'
    elsif auction.future?
      'auction-label-future'
    else
      'auction-label-open'
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

  def auction_human_start_time(auction_time)
    if auction_time < Time.now
      "#{distance_of_time_in_words(Time.now, auction_time)} ago"
    else
      "in #{distance_of_time_in_words(Time.now, auction_time)}"
    end
  end
end
