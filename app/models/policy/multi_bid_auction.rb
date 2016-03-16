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
    lowest_bid
  end

  def winning_bidder_name
    winning_bid.name
  end

  def winning_bid_amount
    lowest_bid_amount
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

  def display_type
    'Multi-bid'
  end

  def rules_href
    '/auctions/rules/multi-bid'
  end
  
  def info_box_partial
    'multi_bid_info_box'
  end

  def win_header_partial
    'auctions/multi_bid_win_header'
  end

  def bid_input_partial
    'auction_input'
  end

  def bid_alert_partial
    'bid_alert'
  end
end
