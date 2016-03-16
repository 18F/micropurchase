class Policy::SingleBidAuction < Policy::Auction
  TYPE_CODE = 'single_bid'.freeze

  # disallow bids if the user has already placed a bid in addition to
  # general bidding rules
  def user_can_bid?
    super && !user_is_bidder?
  end

  def bids?
    return user_is_bidder? if available?
    super
  end

  def highlighted_bid
    if available?
      user_bids.first
    else
      winning_bid
    end
  end

  def winning_bid
    return nil if available?
    return lowest_bids.first if lowest_bids.length == 1
    lowest_bids.sort_by(&:created_at).first
  end

  def winning_bid?(bid)
    return false if bid.nil? || available?
    bid == winning_bid
  end

  def displayed_bids
    if available?
      user_bids
    else
      bids
    end
  end

  def max_possible_bid_amount
    start_price
  end

  def min_possible_bid_amount
    1
  end

  def bid_count
    if available?
      user_bids.count
    else
      super
    end
  end

  def format_type
    'single-bid'
  end
end
