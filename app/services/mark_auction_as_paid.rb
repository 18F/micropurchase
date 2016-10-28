class MarkAuctionAsPaid
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    if auction.purchase_card == 'default'
      auction.update(c2_status: :c2_paid, paid_at: Time.current)
      WinningBidderMailer.auction_paid_default_pcard(auction: auction).deliver_later
    else
      auction.update(paid_at: Time.current)
      WinningBidderMailer.auction_paid_other_pcard(auction: auction).deliver_later
    end
  end
end
