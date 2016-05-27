class AuctionThreshold
  MICROPURCHASE = 3500
  SAT = 150000

  def initialize(auction)
    @auction = auction
  end

  def small_business?
    (MICROPURCHASE + 1..SAT).cover?(auction.start_price)
  end

  private

  attr_reader :auction
end
