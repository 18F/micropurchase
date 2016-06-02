class Rules::SealedBid < Rules::BaseRules
  def winning_bid
    if auction_available?
      NullBid.new
    else
      auction.lowest_bid
    end
  end

  def veiled_bids(user)
    if auction_available?
      auction.bids.where(bidder: user)
    else
      auction.bids
    end
  end

  def user_can_bid?(user)
    super && auction.bids.where(bidder: user).empty?
  end

  def max_allowed_bid
    auction.start_price - PlaceBid::BID_INCREMENT
  end

  def show_bids?
    !auction_available?
  end
end
