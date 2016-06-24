class WinnersViewModel
  def active_count
    AuctionQuery.new.active_auction_count
  end

  def upcoming_count
    AuctionQuery.new.upcoming_auction_count
  end

  def total_auctions
    auction_count
  end

  def unique_auction_winners
    completed_auctions.map do |auction|
      WinningBid.new(auction).find.bidder
    end.uniq.count
  end

  def average_bids_per_auction
    if auction_count > 0
      completed_auctions.map(&:bids).flatten.count / auction_count
    else
      'n/a'
    end
  end

  def vendors_with_bids_count
    User.includes(:bids).where(bids: { bidder_id: nil }).count
  end

  def average_auction_length
    if auction_count > 0
      HumanTime.new(time: (total_auction_time_length / auction_count)).distance_of_time
    else
      'n/a'
    end
  end

  def average_winning_bid
    if auction_count > 0
      Currency.new(total_winning_bid_amount / auction_count).to_s
    else
      'n/a'
    end
  end

  def small_business_count
    User.where(small_business: true).count
  end

  private

  def total_auction_time_length
    completed_auctions.map do |auction|
      auction.ended_at - auction.started_at
    end.reduce(:+)
  end

  def total_winning_bid_amount
    completed_auctions.map do |auction|
      auction.lowest_bid.amount
    end.reduce(:+)
  end

  def auction_count
    @_auction_count ||= completed_auctions.count
  end

  def completed_auctions
    @_completed_auctions ||= AuctionQuery.new.complete_and_successful
  end
end
