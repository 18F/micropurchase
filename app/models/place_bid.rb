class PlaceBid < Struct.new(:params,:current_user)
  BID_LIMIT = 3500.00

  attr_reader :bid

  def perform
    validate_bid_data
    create_bid
  end

  def create_bid
    @bid ||= Bid.create({
      amount: amount,
      bidder_id: current_user.id,
      auction_id: auction.id
    })
  end

  private

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def auction_available?
    Presenter::Auction.new(auction).available?
  end

  def validate_bid_data
    if amount.to_i != amount
      raise UnauthorizedError, 'Bids must be in increments of one dollar'
    end

    if !auction_available?
      raise UnauthorizedError, 'Auction not available'
    end

    if amount > BID_LIMIT
      raise UnauthorizedError, 'Bid too high'
    end

    if amount <= 0
      raise UnauthorizedError, 'Bid amount out of range'
    end
  end

  def amount
    (params[:bid] && params[:bid][:amount]).to_f.round(2)
  end
end
