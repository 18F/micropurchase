class MarkOtherPcardAuctionAsPaid
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    auction.update(paid_at: Time.now)
    AuctionMailer.auction_paid_winning_vendor_other_pcard(auction: auction).deliver_later
  end
end
