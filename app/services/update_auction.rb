class UpdateAuction < Struct.new(:auction, :params, :user)
  def perform
    auction.update(attributes)
  end

  private

  def attributes
    parser.attributes
  end

  def parser
    AuctionParser.new(params, user)
  end
end
