class Policy::Bid
  attr_reader :auction, :bid

  delegate :null, :bidder_id, :amount, :raw_amount, :amount_to_currency, :created_at, :time, :model_name, :to_key,
           to: :bid

  delegate :duns_number, :name, :github_id, to: :bidder, prefix: true

  delegate :veiled_bids?, to: :auction

  def initialize(bid, auction)
    @bid = presenter_bid(bid)
    @auction = auction
  end

  def bidder
    if veiled_bids?
      Presenter::VeiledBidder.new(message: '[Veiled]')
    else
      bid.bidder
    end
  end

  def veiled_bidder_attribute(attribute, show_user = nil, message: nil)
    if veiled_bids?
      message
    else
      bidder.send(attribute) || null
    end
  end

  def amount_to_currency_with_asterisk
    return "#{amount_to_currency} *" if is_winning?
    amount_to_currency
  end

  def is_winning?
    auction.winning_bid? && auction.winning_bid == bid
  end

  def ==(other)
    other = Policy::Bid.new(other, auction) if other.is_a?(::Bid) || other.is_a?(Presenter::Bid)

    bid == other.bid
  end
  
  private

  def presenter_bid(bid)
    case bid
    when Presenter::Bid
      bid
    when ::Bid
      Presenter::Bid.new(bid)
    when nil
      nil
    else
      fail "Unrecognized type for bid: #{bid.klass}"
    end
  end
end
