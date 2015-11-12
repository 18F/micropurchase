class UpdateAuction < Struct.new(:auction, :params)
  def perform
    auction.update(attributes)
  end

  private

  def parser
    AuctionParser.new(params)
  end

  delegate :attributes, to: :parser
end
