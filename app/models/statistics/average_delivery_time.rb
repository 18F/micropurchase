class Statistics::AverageDeliveryTime
  def to_s
    Average.new(
      total_delivery_time_length,
      accepted_auctions.count,
      'time'
    ).to_s
  end

  private

  def total_delivery_time_length
    accepted_auctions.map do |auction|
      auction.accepted_at - auction.ended_at
    end.reduce(:+)
  end

  def accepted_auctions
    @_accepted_auctions ||= AuctionQuery.new.published.accepted
  end
end
