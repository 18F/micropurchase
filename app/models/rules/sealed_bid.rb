class Rules::SealedBid < Rules::Basic
  def winning_bid
    if auction.available?
      NullBidPresenter.new
    else
      auction.lowest_bid
    end
  end

  def veiled_bids(user = nil)
    if auction.available? && user.present?
      auction.bids.where(bidder: user)
    else
      auction.bids.order(created_at: :desc)
    end
  end

  def user_can_bid?(user)
    super && auction.bids.where(bidder: user).empty?
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

  def highlighted_bid(user = nil)
    if auction.available?
      auction.bids.detect { |bid| bid.bidder == user } || NullBidPresenter.new
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
