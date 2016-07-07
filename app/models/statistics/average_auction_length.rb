class Statistics::AverageAuctionLength
  def to_s
    Average.new(
      total_time_length,
      published_auctions.count,
      'time'
    ).to_s
  end

  private

  def total_time_length
    published_auctions.map do |auction|
      auction.ended_at - auction.started_at
    end.reduce(:+)
  end

  def published_auctions
    @_published_auctions ||= AuctionQuery.new.published
  end
end
