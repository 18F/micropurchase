class AcceptAuction
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def perform
    if winning_bidder && winning_bidder.credit_card_form_url.blank?
      AuctionMailer.winning_bidder_missing_payment_method(auction: auction).deliver_later
    else
      auction.accepted_at = Time.current
      UpdateC2ProposalJob.perform_later(auction.id)
      send_customer_email
    end
  end

  private

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def send_customer_email
    if customer && customer.email.present?
      AuctionMailer.auction_accepted_customer_notification(auction: auction).deliver_later
    end
  end

  def customer
    auction.customer
  end
end
