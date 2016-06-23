class HighlightedBid
  attr_reader :auction, :user

  def initialize(auction:, user:)
    @auction = auction
    @user = user
  end

  def find
    if !auction.bids.any?
      NullBid.new
    elsif available_sealed_bid? && user_is_bidder?
      lowest_user_bid
    elsif available_sealed_bid?
      NullBid.new
    else
      auction.lowest_bid
    end
  end

  private

  def available_sealed_bid?
    available? && auction.type == "sealed_bid"
  end

  def available?
    AuctionStatus.new(auction).available?
  end

  def user_is_bidder?
    user_bids.any?
  end

  def lowest_user_bid
    user_bids.first
  end

  def user_bids
    auction.bids.where(bidder: user).order(amount: :asc)
  end
end
