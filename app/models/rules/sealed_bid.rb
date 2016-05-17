class Rules::SealedBid < Rules::BaseRules
  def winning_bid
    if auction_available?
      NullBidPresenter.new
    else
      auction.lowest_bid
    end
  end

  def veiled_bids(user)
    if auction_available?
      auction.bids.select { |bid| bid.bidder == user }
    else
      auction.bids
    end
  end

  def user_can_bid?(user)
    super && !auction.bids.any? { |b| b.bidder == user }
  end

  def max_allowed_bid
    auction.start_price - PlaceBid::BID_INCREMENT
  end

  def show_bids?
    !auction_available?
  end

  def partial_prefix
    'single_bid'
  end

  def formatted_type
    'single-bid'
  end

  def highlighted_bid(user)
    if auction_available?
      auction.bids.detect { |bid| bid.bidder_id == user.id } || NullBidPresenter.new
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

  private

  def auction_available?
    AuctionStatus.new(auction).available?
  end
end
