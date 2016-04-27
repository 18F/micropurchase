class CreateAuction < Struct.new(:params)
  attr_reader :auction

  def perform
    @auction = Auction.create(attributes)
  end

  private

  def attributes
    AuctionParser.new(params).attributes
  end
end
