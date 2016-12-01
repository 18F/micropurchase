class MarkAuctionDeliveryMissed
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    auction.delivery_status = :missed_delivery
    WinningBidderMailer.auction_not_delivered(auction: auction).deliver_later
  end
end
