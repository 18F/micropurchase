class AuctionEndedJob
  def initialize(auction_id)
    @auction = Auction.find(auction_id)
  end

  def perform
    WinningBidderEmailSender.new(auction).perform
    LosingBidderEmailSender.new(auction).perform
  end

  private

  attr_reader :auction
end
