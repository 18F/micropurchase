class CreateAuctionEndedJob
  def initialize(auction)
    @auction = auction
  end

  def perform
    if auction_not_over?
      Delayed::Job.enqueue(
        job,
        run_at: auction.ended_at,
        queue: 'auction_ended',
        auction_id: auction.id
      )
    end
  end

  private

  attr_reader :auction

  def job
    AuctionEndedJob.new(auction.id)
  end

  def auction_not_over?
    !BiddingStatus.new(auction).over?
  end
end
