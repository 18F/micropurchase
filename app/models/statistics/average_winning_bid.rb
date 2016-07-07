class Statistics::AverageWinningBid
  def to_s
    Average.new(
      total_winning_bid_amount,
      completed_auctions.count,
      'price'
    ).to_s
  end

  private

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
