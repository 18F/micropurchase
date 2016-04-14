class PlaceBid < Struct.new(:params, :current_user)
  BID_LIMIT = 3500
  BID_INCREMENT = 1

  attr_reader :bid

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
      bidder_id: current_user.id,
      auction_id: auction.id
    )
  end

  def unsaveable_bid
    @bid ||= Bid.new(
      amount: amount,
      bidder_id: current_user.id,
      auction_id: auction.id
    )

    @bid.readonly!
    @bid
  end

  private

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def auction_available?
    Presenter::Auction.new(auction).available?
  end

  def max_allowed_bid
    Presenter::Auction.new(auction).max_allowed_bid
  end

  def auction_is_single_bid?
    auction.type == 'single_bid'
  end

  def auction_is_multi_bid?
    auction.type == 'multi_bid'
  end

  def bidder_already_bid_on_this_auction?
    return false if auction.bids.empty?

    auction.bids.map(&:bidder_id).include?(current_user.id)
  end

  # rubocop:disable Style/IfUnlessModifier, Style/GuardClause
  def validate_bid_data
    if auction_is_single_bid? && bidder_already_bid_on_this_auction?
      fail UnauthorizedError, 'You can only bid once in a single-bid auction.'
    end

    if amount.to_i != amount
      fail UnauthorizedError, 'Bids must be in increments of one dollar'
    end

    unless auction_available?
      fail UnauthorizedError, 'Auction not available'
    end

    if amount > BID_LIMIT
      fail UnauthorizedError, 'Bid too high'
    end

    if amount <= 0
      fail UnauthorizedError, 'Bid amount out of range'
    end

    if auction_is_multi_bid? && amount > max_allowed_bid
      fail UnauthorizedError, "Bids cannot be greater than the current max bid"
    end
  end
  # rubocop:enable Style/IfUnlessModifier, Style/GuardClause

  def amount
    params_amount = params[:bid][:amount]
    params_amount = params_amount.delete(',') if params_amount.is_a?(String)

    (params[:bid] && params_amount).to_f.round(2)
  end
end
