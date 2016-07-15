class AcceptAuction
  attr_reader :auction, :payment_url

  def initialize(auction:, payment_url: '')
    @auction = auction
    @payment_url = payment_url
  end

  def perform
    if payment_url.blank?
      send_winning_vendor_email
    else
      auction.accepted_at = Time.current
      send_customer_email
      update_purchase_request
    end
  end

  private

  def send_winning_vendor_email
    AuctionMailer
      .winning_bidder_missing_payment_method(auction: auction)
      .deliver_later
  end

  def send_customer_email
    if customer && customer.email.present?
      AuctionMailer
        .auction_accepted_customer_notification(auction: auction)
        .deliver_later
    end
  end

  def update_purchase_request
    if auction.purchase_card == "default"
      UpdateC2ProposalJob.perform_later(auction.id)
    end
  end

  def customer
    auction.customer
  end
end
