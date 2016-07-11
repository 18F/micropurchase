class AcceptAuction
  attr_reader :auction, :credit_card_form_url

  def initialize(auction:, credit_card_form_url: '')
    @auction = auction
    @credit_card_form_url = credit_card_form_url
  end

  def perform
    if credit_card_form_url.blank?
      AuctionMailer
        .winning_bidder_missing_payment_method(auction: auction)
        .deliver_later
    else
      auction.accepted_at = Time.current
      send_customer_email
      update_purchase_request
    end
  end

  private

  def winning_bidder
    WinningBid.new(auction).find.bidder
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
