class Policy::Bid
  attr_reader :bid, :auction

  delegate :bidder_duns_number, :bidder_name, :null, :amount_to_currency, :amount_to_currency_with_asterix,
           to: :bid
  
  def initialize(bid, policy_auction)
    @bid = Presenter::Bid.new(bid)
    @auction = policy_auction
  end
  
  def bidder
    if veiled?
      Presenter::VeiledBidder.new(message: message)
    else
      bidder
    end
  end

  def is_winning?
    auction.winning_bid?(bid)
  end
end
