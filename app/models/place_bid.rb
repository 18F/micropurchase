class PlaceBid
  BID_LIMIT = 3500
  BID_INCREMENT = 1

  attr_reader :bid, :params, :user, :via

  def initialize(params:, user:, via:nil)
    @params = params
    @user = user
    @via = via
  end

  def perform
    validate_bid_data
    create_bid
  end

  def dry_run
    validate_bid_data
    unsaveable_bid
  end

  def create_bid
    @bid ||= Bid.create(
      amount: amount,
      bidder_id: user.id,
      auction_id: auction.id,
      via: via
    )
  end

  def unsaveable_bid
    @bid ||= Bid.new(
      amount: amount,
      bidder_id: user.id,
      auction_id: auction.id,
      via: via
    )

    @bid.readonly!
    @bid
  end

  private

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def user_can_bid?
    presenter_auction.user_can_bid?(user)
  end

  def max_allowed_bid
    presenter_auction.max_allowed_bid
  end

  def validate_bid_data
    unless auction_available?
      fail UnauthorizedError, 'Auction not available'
    end

    unless user_can_bid?
      fail UnauthorizedError, 'You are not allowed to bid on this auction'
    end

    if amount.to_i != amount
      fail UnauthorizedError, 'Bids must be in increments of one dollar'
    end

    if amount > BID_LIMIT
      fail UnauthorizedError, 'Bid too high'
    end

    if amount <= 0
      fail UnauthorizedError, 'Bid amount out of range'
    end

    if amount > max_allowed_bid
      fail UnauthorizedError, "Bids cannot be greater than the current max bid"
    end
  end

  def auction_available?
    AuctionStatus.new(auction).available?
  end

  def amount
    params_amount = params[:bid][:amount]
    params_amount = params_amount.delete(',') if params_amount.is_a?(String)

    (params[:bid] && params_amount).to_f.round(2)
  end

  def presenter_auction
    @presenter ||= AuctionPresenter.new(auction)
  end
end
