class DestroyAuction < Struct.new(:auction)
  def perform
    auction.destroy
  end
end
