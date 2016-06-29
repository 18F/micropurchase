class InsightsViewModel
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
      unique_bidders_count_per_auction,
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
    calculate_average(total_auction_time_length, published_auction_count, 'time')
  end

  def average_delivery_time
    calculate_average(total_delivery_time_length, accepted_auctions_count, 'time')
  end

  def average_winning_bid
    calculate_average(total_winning_bid_amount, completed_auction_count, 'price')
  end

  def average_starting_price
    calculate_average(total_starting_price, completed_auction_count, 'price')
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

  def unique_bidders_count_per_auction
    completed_auctions.map(&:bidders).map do |bidders|
      bidders.uniq.size
    end.reduce(:+)
  end

  def total_delivery_time_length
    total_time_length(accepted_auctions, 'accepted_at', 'ended_at')
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

  def calculate_average(value, auction_count, type = nil)
    if auction_count > 0
      calculate(value, auction_count, type)
    else
      'n/a'
    end
  end

  def calculate(value, auction_count, type = nil)
    if type == 'time'
      HumanTime.new(time: (value / auction_count)).distance_of_time
    elsif type == 'price'
      Currency.new(value / auction_count).to_s
    else
      (value / auction_count.to_f).round
    end
  end
end
