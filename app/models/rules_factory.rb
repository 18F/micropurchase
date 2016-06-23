class RulesFactory
  def initialize(auction)
    @auction = auction
    @eligibility = EligibilityFactory.new(@auction).create
  end

  def create
    if type == 'sealed_bid'
      Rules::SealedBidAuction.new(auction, eligibility)
    elsif type == 'reverse'
      Rules::ReverseAuction.new(auction, eligibility)
    end
  end

  private

  attr_reader :auction
  attr_reader :eligibility

  def type
    auction.type
  end
end
