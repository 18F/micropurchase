class Policy::MultiBidAuction < Policy::Auction
  # This overrides less of the auction policy
  TYPE_CODE = 'multi_bid'

  def has_bids?
    bid_count > 0
  end
  
  def displayed_bids
    bids
  end

  def max_possible_bid_amount
    return start_price - BID_INCREMENT if lowest_bid_amount.nil?
    lowest_bid_amount - BID_INCREMENT
  end

  def min_possible_bid_amount
    1
  end

  def validate_bid(amount)
    super

    if amount > max_possible_bid_amount
      fail UnauthorizedError, "Bids cannot be greater than the current max bid"
    end
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
    'auctions/multi_bid/info_box'
  end

  def win_header_partial
    'auctions/multi_bid/win_header'
  end

  def bid_input_partial
    'auction_input'
  end

  def bid_alert_partial
    'bid_alert'
  end
end
