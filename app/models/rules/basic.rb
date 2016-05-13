class Rules::Basic < Rules::BaseRules
  def winning_bid
    auction.lowest_bid
  end

  def veiled_bids(user)
    auction.bids
  end

  def max_allowed_bid
    if auction.lowest_bid.is_a?(NullBidPresenter)
      return auction.start_price - PlaceBid::BID_INCREMENT
    else
      return auction.lowest_bid_amount - PlaceBid::BID_INCREMENT
    end
  end

  def highlighted_bid(user)
    auction.lowest_bid
  end

  def show_bids?
    true
  end

  def partial_prefix
    'multi_bid'
  end

  def formatted_type
    'multi-bid'
  end

  def highlighted_bid_label
    'Current bid:'
  end

  def auction_rules_href
    '/auctions/rules/multi-bid'
  end
end
