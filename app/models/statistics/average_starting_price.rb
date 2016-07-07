class Statistics::AverageStartingPrice
  def to_s
    Average.new(
      total_starting_price,
      completed_auctions.count,
      'price'
    ).to_s
  end

  private

  def total_starting_price
    completed_auctions.map(&:start_price).reduce(:+)
  end

  def completed_auctions
    @_completed_auctions ||= AuctionQuery.new.completed
  end
end
