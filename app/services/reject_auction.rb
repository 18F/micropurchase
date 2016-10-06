class RejectAuction
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def perform
    auction.delivery_status = :rejected
    auction.rejected_at = Time.current
    update_c2_status
    WinningBidderMailer.auction_rejected(auction: auction).deliver_later
    auction.save
  end

  private

  def update_c2_status
    if auction.c2_proposal_url.present?
      UpdateC2ProposalJob.perform_later(auction.id, 'C2CancelAttributes')
      auction.c2_status = :c2_canceled
    end
  end
end
