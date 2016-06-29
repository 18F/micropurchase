class SaveAuction
  def initialize(auction)
    @auction = auction
  end

  def perform
    auction.save
  end

  private

  attr_reader :auction
end
