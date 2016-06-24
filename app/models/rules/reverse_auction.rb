class Rules::ReverseAuction < Rules::BaseRules
  def winning_bid
    auction.lowest_bid || NullBid.new
  end

  def highlighted_bid(_user)
    winning_bid
  end

  def veiled_bids(_user)
    auction.bids
  end

  def max_allowed_bid
    if auction.lowest_bid.is_a?(NullBid) || auction.lowest_bid.nil?
      auction.start_price - PlaceBid::BID_INCREMENT
    else
      auction.lowest_bid.amount - PlaceBid::BID_INCREMENT
    end
  end

  def show_bids?
    true
  end
end
