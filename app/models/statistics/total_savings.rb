class Statistics::TotalSavings
  def to_s
    if completed_auctions.count > 0
      Currency.new(total_starting_price - total_winning_bid_amount).to_s
    else
      'n/a'
    end
  end

  private

  def total_starting_price
    completed_auctions.map(&:start_price).reduce(:+)
  end

  def total_winning_bid_amount
    completed_auctions
      .map(&:lowest_bid)
      .map(&:amount)
      .reject(&:nil?)
      .reduce(:+)
  end

  def completed_auctions
    @_completed_auctions ||= AuctionQuery.new.completed
  end
end
