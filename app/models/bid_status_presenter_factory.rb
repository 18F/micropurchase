class BidStatusPresenterFactory
  attr_reader :auction, :user

  def initialize(auction:, user:)
    @auction = auction
    @user = user
  end

  def create
    if future?
      future_message
    elsif over?
      over_message
    else
      available_message
    end
  end

  private

  def available_message
    if admin?
      BidStatusPresenter::AvailableUserIsAdmin.new(auction: auction)
    elsif guest?
      BidStatusPresenter::AvailableUserIsGuest.new(auction: auction)
    elsif auction.type == 'reverse'
      BidStatusPresenter::AvailableUserIsWinningBidder.new(bid_amount: lowest_user_bid.try(:amount))
    else # sealed bid, user is bidder
      BidStatusPresenter::AvailableSealedUserIsBidder.new(bid: lowest_user_bid)
    end
  end

  def future_message
    if admin?
      BidStatusPresenter::FutureUserIsAdmin.new(auction: auction)
    elsif guest?
      BidStatusPresenter::FutureUserIsGuest.new(auction: auction)
    else
      BidStatusPresenter::FutureUserIsVendor.new(auction: auction)
    end
  end

  def over_message
    if user_is_winning_bidder? && auction.delivery_url.present?
      BidStatusPresenter::OverUserIsWinnerWorkInProgress.new(auction: auction)
    elsif user_is_winning_bidder?
      BidStatusPresenter::OverUserIsWinner.new(auction: auction)
    elsif user_is_bidder?
      BidStatusPresenter::OverUserIsBidder.new
    elsif auction.bids.any?
      BidStatusPresenter::OverWithBids.new
    else
      BidStatusPresenter::OverNoBids.new
    end
  end

  def admin?
    user.decorate.admin?
  end

  def guest?
    user.is_a?(Guest)
  end

  def over?
    auction_status.over?
  end

  def available?
    auction_status.available?
  end

  def future?
    auction_status.future?
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
