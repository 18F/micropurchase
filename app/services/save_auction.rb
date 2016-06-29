class SaveAuction
  def initialize(auction)
    @auction = auction
  end

  def perform
    saved = auction.save
    schedule_auction_ended_job(saved)

    saved
  end

  private

  attr_reader :auction

  def schedule_auction_ended_job(saved)
    if should_schedule_auction_ended_job?(saved)
      AuctionEnded.new(auction).delay(run_at: auction.ended_at).perform
    end
  end

  def should_schedule_auction_ended_job?(saved)
    saved && !auction.ended_at.nil?
  end
end
