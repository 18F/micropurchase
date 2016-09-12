class AcceptAuction
  attr_reader :auction, :payment_url

  def initialize(auction:, payment_url: '')
    @auction = auction
    @payment_url = payment_url
  end

  def perform
    if payment_url.blank?
      send_winning_bidder_missing_payment_method_email
    else
      auction.accepted_at = Time.current
      send_auction_accepted_emails
      update_purchase_request
    end
  end

  private

  def send_winning_bidder_missing_payment_method_email
    WinningBidderMailer
      .auction_accepted_missing_payment_method(auction: auction)
      .deliver_later
  end

  def send_auction_accepted_emails
    WinningBidderMailer.auction_accepted(auction: auction).deliver_later
    if customer && customer.email.present?
      AuctionMailer
        .auction_accepted_customer_notification(auction: auction)
        .deliver_later
    end
  end

  def update_purchase_request
    if auction.purchase_card == "default"
      UpdateC2ProposalJob.perform_later(auction.id, 'C2UpdateAttributes')
    end
  end

  def customer
    auction.customer
  end
end
