class Rules::SealedBid < Rules::Basic
  def winning_bid
    if auction.available?
      BidPresenter::Null.new
    else
      auction.lowest_bid
    end
  end

  def veiled_bids(user)
    if auction.available?
      return [] if user.nil?
      auction.bids.select { |bid| bid.bidder_id == user.id }
    else
      auction.bids
    end
  end

  def user_can_bid?(user)
    super && !auction.bids.any? { |b| b.bidder_id == user.id }
  end

  def max_allowed_bid
    auction.start_price - PlaceBid::BID_INCREMENT
  end

  def show_bids?
    !auction.available?
  end

  def partial_prefix
    'single_bid'
  end

  def formatted_type
    'single-bid'
  end

  def highlighted_bid(user)
    if auction.available?
      auction.bids.detect { |bid| bid.bidder_id == user.id } || BidPresenter::Null.new
    else
      auction.lowest_bid
    end
  end

  def highlighted_bid_label
    'Your bid:'
  end

  def auction_rules_href
    '/auction/rules/single-bid'
  end
end
