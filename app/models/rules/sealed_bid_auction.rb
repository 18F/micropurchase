class Rules::SealedBidAuction < Rules::BaseRules
  def winning_bid
    if auction_available?
      NullBid.new
    else
      auction.lowest_bid
    end
  end

  def highlighted_bid(user)
    if auction_available?
      lowest_user_bid(user)
    else
      winning_bid
    end
  end

  def veiled_bids(user)
    if auction_available?
      auction.bids.where(bidder: user)
    else
      auction.bids
    end
  end

  def user_is_bidder?(user)
    user_bids(user).any?
  end

  def user_can_bid?(user)
    super && !user_is_bidder?(user)
  end

  def max_allowed_bid
    auction.start_price - PlaceBid::BID_INCREMENT
  end

  def show_bids?
    !auction_available?
  end

  private

  def lowest_user_bid(user)
    user_bids(user).first || NullBid.new
  end

  def user_bids(user)
    auction.bids.where(bidder: user).order(amount: :asc)
  end
end
