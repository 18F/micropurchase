class PlaceBid < Struct.new(:auction, :params)
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
      bidder_id: current_user_id,
      auction_id: auction.id
    )
  end

  def unsaveable_bid
    @bid ||= Bid.new(
      amount: amount,
      bidder_id: current_user_id,
      auction_id: auction.id
    )

    @bid.readonly!
    @bid
  end

  private

  def auction_available?
    auction.available?
  end

  def current_max_bid
    auction.current_max_bid
  end

  def current_user_id
    auction.user_id
  end
  
  def validate_bid_data
    auction.validate_bid(amount)
  end
  
  def amount
    params_amount = params[:bid][:amount]
    params_amount = params_amount.delete(',') if params_amount.is_a?(String)

    (params[:bid] && params_amount).to_f.round(2)
  end
end
