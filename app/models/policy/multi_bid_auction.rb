class Policy::MultiBidAuction < Policy::Auction
  # This overrides less of the auction policy
  TYPE_CODE = 'multi_bid'

  def has_bids?
    bid_count > 0
  end

  def highlighted_bid
    winning_bid
  end

  def winning_bid
    lowest_bids.first
  end

  def displayed_bids
    bids
  end

  def max_possible_bid_amount
    return start_price if lowest_bid_amount.nil?
    lowest_bid_amount - PlaceBid::BID_INCREMENT
  end

  def min_possible_bid_amount
    1
  end

  def format_type
    'multi-bid'
  end
end
