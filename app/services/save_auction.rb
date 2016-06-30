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
      job = AuctionEndedJob.new(auction.id)
      Delayed::Job.enqueue(job,
                           run_at: auction.ended_at,
                           queue: 'auction_ended',
                           auction_id: auction.id)
    end
  end
end
