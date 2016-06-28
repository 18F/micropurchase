class AuctionEnded
  def initialize(auction)
    @auction = auction
  end

  def perform
    WinningBidderEmailSender.new(auction).perform
    LosingBidderEmailSender.new(auction).perform
  end

  private

  attr_reader :auction
end
