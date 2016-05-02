class RulesFactory
  def initialize(auction)
    @auction = auction
  end

  def create
    if type == 'single_bid'
      Rules::SealedBid.new(auction)
    elsif type == 'multi_bid'
      Rules::Basic.new(auction)
    end
  end

  private

  attr_reader :auction

  def type
    auction.type
  end
end
