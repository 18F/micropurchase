class AuctionReceiptShowViewModel
  def initialize(auction)
    @auction = auction
  end

  def auction_id
    auction.id
  end

  def auction_url
    AuctionUrl.new(auction: auction).to_s
  end

  def auction_paid_at
    DcTimePresenter.convert_and_format(auction.paid_at)
  end

  def auction_description
    auction.description
  end

  def auction_c2_status
    auction.c2_status
  end

  def winning_bid_amount
    Currency.new(winning_bid.amount).to_s
  end

  def winning_bidder_name
    winning_bidder.name
  end

  def winning_bidder_email
    winning_bidder.email
  end

  private

  attr_reader :auction

  def winning_bid
    @_winning_bid ||= WinningBid.new(auction).find
  end

  def winning_bidder
    winning_bid.bidder
  end
end
