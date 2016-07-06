class SaveAuction
  def initialize(auction)
    @auction = auction
  end

  def perform
    auction.save
    schedule_auction_ended_job
    auction.persisted?
  end

  private

  attr_reader :auction

  def schedule_auction_ended_job
    if auction.persisted?
      CreateAuctionEndedJob.new(auction).perform
    end
  end
end
