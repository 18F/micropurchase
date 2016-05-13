class LosingBidderEmailSender
  def initialize(auction)
    @auction = auction
  end

  def perform
    losing_bidders_with_emails.each do |bidder|
      AuctionMailer
        .losing_bidder_notification(bidder: bidder, auction: auction)
        .deliver_later
    end
  end

  private

  attr_reader :auction

  def losing_bidders_with_emails
    losing_bidders.select do |bidder|
      bidder.email.present?
    end
  end

  def losing_bidders
    if winning_bid
      auction.bids.map(&:bidder).uniq - [winning_bid.bidder]
    else
      User.none
    end
  end

  def winning_bid
    auction_rules.winning_bid
  end

  def auction_rules
    RulesFactory.new(auction).create
  end
end
