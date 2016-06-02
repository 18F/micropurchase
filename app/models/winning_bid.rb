class WinningBid
  def initialize(auction)
    @auction = auction
  end

  def find
    auction_rules.winning_bid
  end

  private

  attr_reader :auction

  def auction_rules
    RulesFactory.new(auction).create
  end
end
