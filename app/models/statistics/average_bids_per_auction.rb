class Statistics::AverageBidsPerAuction
  def to_s
    Average.new(
      completed_auctions.map(&:bids).flatten.count,
      completed_auctions.count
    ).to_s
  end

  private

  def completed_auctions
    @_completed_auctions ||= AuctionQuery.new.completed
  end
end
