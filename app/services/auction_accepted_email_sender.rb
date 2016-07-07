class AuctionAcceptedEmailSender
  attr_reader :auction

  def initialize(auction)
    @auction = auction
  end

  def perform
    if customer && customer.email.present?
      AuctionMailer.auction_accepted_customer_notification(auction: auction)
    end
  end

  private

  def customer
    auction.customer
  end
end
