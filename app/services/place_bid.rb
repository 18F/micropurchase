class PlaceBid
  BID_INCREMENT = 1

  def initialize(params:, user:, via:nil)
    @params = params
    @user = user
    @via = via
  end

  def valid?
    validate_bid_data
    bid.errors.empty?
  end

  def errors
    bid.errors.full_messages.to_sentence
  end

  def perform
    if valid?
      bid.save
    end
  end

  def dry_run
    bid.readonly!
    bid
  end

  def bid
    @_bid ||= Bid.new(amount: amount, auction: auction, bidder: user, via: via)
  end

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  private

  attr_reader :params, :user, :via

  def validate_bid_data
    @_validate_bid_data ||= BidValidator.new.validate(bid)
  end

  def amount
    params_amount = params[:bid][:amount]
    params_amount = params_amount.delete(',') if params_amount.is_a?(String)

    (params[:bid] && params_amount).to_f.round(2)
  end
end
