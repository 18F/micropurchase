class LosingBidderEmailSender
  def initialize(auction)
    @auction = auction
  end

  def perform
    losing_bids_with_emails.each do |bid|
      AuctionMailer.losing_bidder_notification(bid).deliver_later
    end
  end

  private

  attr_reader :auction

  def losing_bids_with_emails
    losing_bids.includes(:bidder).select do |bid|
      bid.bidder.email.present?
    end
  end

  def losing_bids
    if winning_bid
      auction.bids.where.not(id: winning_bid.id)
    else
      Bid.none
    end
  end

  def winning_bid
    auction_rules.winning_bid
  end

  def auction_rules
    RulesFactory.new(auction).create
  end
end
