class BidStatusFlashFactory
  attr_reader :auction, :flash, :user

  def initialize(auction:, flash:, user:)
    @auction = auction
    @flash = flash
    @user = user
  end

  def create
    if available?
      available_flash
    else
      over_flash
    end
  end

  private

  def available_flash
    if user_is_bidder? && flash['bid']
      BidSubmitted.new
    elsif user_is_winning_bidder?
      AvailableUserIsWinningBidder.new
    else # user is bidder
      AvailableUserIsBidder.new(bid_amount: lowest_user_bid.try(:amount))
    end
  end

  def over_flash
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
  def alert_class
    'info'
  end

  def header
    'Auction Now Closed'
  end

  def body
    ''
  end
end

class OverUserIsWinner
  def alert_class
    'success'
  end

  def header
    'You are the winner'
  end

  def body
    'Congratulations! We will contact you with further instructions.'
  end
end

class OverUserIsBidder
  def alert_class
    'error'
  end

  def header
    'You are not the winner'
  end

  def body
    'Someone else placed a lower bid than you.'
  end
end

class OverNoBids
  def alert_class
    'alert'
  end

  def header
    'Auction Now Closed'
  end

  def body
    'This auction ended with no bids.'
  end
end

class BidSubmitted
  def alert_class
    'success'
  end

  def header
    'Bid Submitted! You currently have the winning bid.'
  end

  def body
    "If your bid is selected as the winner, we will contact you with further
    instructions. <a class='button-view-bids' href='/my-bids'>View your bids <icon
    class='fa fa-angle-double-right'></icon></a>".html_safe
  end
end

class AvailableUserIsWinningBidder
  def alert_class
    'success'
  end

  def header
    'You currently have the winning bid.'
  end

  def body
    'If your bid is selected as the winner, we will contact you with further instructions.'
  end
end

class AvailableUserIsBidder
  attr_reader :bid_amount

  def initialize(bid_amount:)
    @bid_amount = bid_amount
  end

  def alert_class
    'success'
  end

  def header
    'Your bid:'
  end

  def body
    Currency.new(bid_amount).to_s
  end
end
