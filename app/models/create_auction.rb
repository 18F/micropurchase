class CreateAuction < Struct.new(:params)
  attr_reader :auction

  def perform
    @auction = Auction.create(attributes)
  end

  private

  def parser
    AuctionParser.new(params)
  end

  delegate :attributes, to: :parser
end
