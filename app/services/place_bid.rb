class PlaceBid
  include ActiveModel::Validations

  BID_INCREMENT = 1

  attr_reader :params, :bidder, :via

  validates_with PlaceBidValidator

  def initialize(params:, bidder:, via: nil)
    @params = params
    @bidder = bidder
    @via = via
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
    @_bid ||= Bid.new(amount: amount, auction: auction, bidder: bidder, via: via)
  end

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def amount
    params_amount = params[:bid][:amount]
    params_amount = params_amount.delete(',') if params_amount.is_a?(String)

    (params[:bid] && params_amount).to_f.round(2)
  end
end
