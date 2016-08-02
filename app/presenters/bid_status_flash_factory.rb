class BidStatusFlashFactory
  attr_reader :auction, :user

  def initialize(auction:, user:)
    @auction = auction
    @user = user
  end

  def create
    if available?
      AvailableUserIsWinningBidder.new(bid_amount: lowest_user_bid.try(:amount))
    else
      over_message
    end
  end

  private

  def over_message
    if user_is_winning_bidder?
      OverUserIsWinner.new
    elsif user_is_bidder?
      OverUserIsBidder.new
    elsif auction.bids.any?
      OverWithBids.new
    else
      OverNoBids.new
    end
  end

  def over?
    auction_status.over?
  end

  def available?
    auction_status.available?
  end

  def auction_status
    AuctionStatus.new(auction)
  end

  def user_is_winning_bidder?
    user_bids.any? && lowest_user_bid == auction.lowest_bid
  end

  def user_is_bidder?
    user_bids.any?
  end

  def lowest_user_bid
    user_bids.order(amount: :asc).first
  end

  def user_bids
    auction.bids.where(bidder: user)
  end
end

class OverWithBids
  def header
    'Auction Now Closed'
  end

  def body
    ''
  end
end

class OverUserIsWinner
  def header
    'You are the winner'
  end

  def body
    'Congratulations! We will contact you with further instructions.'
  end
end

class OverUserIsBidder
  def header
    'You are not the winner'
  end

  def body
    'Someone else placed a lower bid than you.'
  end
end

class OverNoBids
  def header
    'Auction Now Closed'
  end

  def body
    'This auction ended with no bids.'
  end
end

class AvailableUserIsWinningBidder
  attr_reader :bid_amount

  def initialize(bid_amount:)
    @bid_amount = bid_amount
  end

  def header
    'Bid placed'
  end

  def body
    "You are currently the low bidder, with a bid of #{Currency.new(bid_amount)}"
  end
end
