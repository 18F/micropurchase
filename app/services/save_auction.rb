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
    if saved
      job = AuctionEndedJob.new(auction.id)
      Delayed::Job.enqueue(job, run_at: auction.ended_at)
    end
  end
end
