class PlaceBid < Struct.new(:params, :current_user)
  BID_LIMIT = 3500
  BID_INCREMENT = 1

  attr_reader :bid

  def perform
    validate_bid_data
    create_bid
  end

  def create_bid
    @bid ||= Bid.create(
      amount: amount,
      bidder_id: current_user.id,
      auction_id: auction.id
    )
  end

  private

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def auction_available?
    Presenter::Auction.new(auction).available?
  end

  def current_max_bid
    Presenter::Auction.new(auction).current_max_bid
  end

  # rubocop:disable Style/IfUnlessModifier, Style/GuardClause
  def validate_bid_data
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

    if amount > current_max_bid
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
