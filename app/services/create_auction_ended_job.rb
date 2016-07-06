class CreateAuctionEndedJob
  def initialize(auction)
    @auction = auction
  end

  def perform
    Delayed::Job.enqueue(
      job,
      run_at: auction.ended_at,
      queue: 'auction_ended',
      auction_id: auction.id
    )
  end

  private

  attr_reader :auction

  def job
    AuctionEndedJob.new(auction.id)
  end
end
