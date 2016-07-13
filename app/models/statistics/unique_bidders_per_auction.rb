class Statistics::UniqueBiddersPerAuction
  def to_s
    Average.new(
      unique_bidders_count_per_auction,
      completed_auctions.count
    ).to_s
  end

  private

  def unique_bidders_count_per_auction
    completed_auctions.map(&:bidders).map do |bidders|
      bidders.uniq.size
    end.reduce(:+)
  end

  def completed_auctions
    @_completed_auctions ||= AuctionQuery.new.completed
  end
end
