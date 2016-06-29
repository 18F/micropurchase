class WinnersViewModel
  def active_count
    AuctionQuery.new.active_auction_count
  end

  def upcoming_count
    AuctionQuery.new.upcoming_auction_count
  end

  def total_auctions
    published_auction_count
  end

  def unique_bidders_per_auction
    calculate_average(
      completed_auctions.map(&:bidders).flatten.uniq.count,
      completed_auction_count
    )
  end

  def unique_auction_winners
    completed_auctions.map do |auction|
      WinningBid.new(auction).find.bidder
    end.uniq.count
  end

  def average_bids_per_auction
    calculate_average(
      completed_auctions.map(&:bids).flatten.count,
      completed_auction_count
    )
  end

  def vendors_with_bids_count
    UserQuery.new.with_bids.count
  end

  def average_auction_length
    calculate_average_time(total_auction_time_length, published_auction_count)
  end

  def average_delivery_time
    calculate_average_time(total_delivery_time_length, accepted_auctions_count)
  end

  def average_winning_bid
    calculate_average_price(total_winning_bid_amount, completed_auction_count)
  end

  def average_starting_price
    calculate_average_price(total_starting_price, completed_auction_count)
  end

  def small_business_count
    UserQuery.new.small_business.count
  end

  def in_sam_count
    UserQuery.new.in_sam.count
  end

  def accepted_auctions_count
    accepted_auctions.count
  end

  private

  def total_delivery_time_length
    total_time_length(published_auctions, 'delivery_due_at', 'ended_at')
  end

  def total_auction_time_length
    total_time_length(published_auctions, 'ended_at', 'started_at')
  end

  def total_time_length(auctions, first_time, second_time)
    auctions.map do |auction|
      auction.send(first_time) - auction.send(second_time)
    end.reduce(:+)
  end

  def total_winning_bid_amount
    completed_auctions
      .map(&:lowest_bid)
      .map(&:amount)
      .reject(&:nil?)
      .reduce(:+)
  end

  def total_starting_price
    completed_auctions.map(&:start_price).reduce(:+)
  end

  def published_auction_count
    @_published_auction_count ||= published_auctions.count
  end

  def completed_auction_count
    @_completed_auction_count ||= completed_auctions.count
  end

  def completed_auctions
    @_completed_auctions ||=
      AuctionQuery
      .new
      .published
      .delivery_due_at_expired
      .with_bids_and_bidders
      .where.not(bids: { id: nil })
  end

  def accepted_auctions
    @_accepted_auctions ||= AuctionQuery.new.published.accepted
  end

  def published_auctions
    @_published_auctions ||= AuctionQuery.new.published
  end

  def calculate_average(value, auction_count)
    if auction_count > 0
      value / auction_count
    else
      'n/a'
    end
  end

  def calculate_average_time(value, auction_count)
    if auction_count > 0
      HumanTime.new(time: (value / auction_count)).distance_of_time
    else
      'n/a'
    end
  end

  def calculate_average_price(amount, auction_count)
    if auction_count > 0
      Currency.new(amount / auction_count).to_s
    else
      'n/a'
    end
  end
end
