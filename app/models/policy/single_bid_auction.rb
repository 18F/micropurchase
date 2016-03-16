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
    return Presenter::Bid::Null.new if available?
    return lowest_bids.first if lowest_bids.length == 1
    lowest_bids.sort_by(&:created_at).first
  end

  def winning_bidder_name
    winning_bid.name
  end

  def winning_bid_amount
    winning_bid.amount
  end
  
  def bid_is_winner?(bid)
    return false if bid.nil? || available?
    bid == winning_bid
  end

  def user_is_winner?
    return false if available? || !bids?
    winning_bid.bidder_id == user.id
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

  def display_type
    'Single Bid'
  end

  def open_bid_status_label
    'Your bid:'
  end

  def status_partial
    if over?
      super
    else
      'auctions/single_bid_auction_status'
    end
  end
  
  def rules_href
    '/auctions/rules/single-bid'
  end
  
  def info_box_partial
    'single_bid_info_box'
  end

  def win_header_partial
    'auctions/single_bid_win_header'
  end  

  def bid_input_partial
    'auction_input'
  end

  def bid_alert_partial
    'bid_alert_single_bid_auction'
  end
end
