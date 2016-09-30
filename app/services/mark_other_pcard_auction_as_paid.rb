class MarkOtherPcardAuctionAsPaid
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    auction.update(paid_at: Time.current)
    WinningBidderMailer.auction_paid_other_pcard(auction: auction).deliver_later
  end
end
