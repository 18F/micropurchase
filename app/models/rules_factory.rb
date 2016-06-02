class RulesFactory
  def initialize(auction)
    @auction = auction
    @eligibility = EligibilityFactory.new(@auction).create
  end

  def create
    if type == 'single_bid'
      Rules::SealedBid.new(auction, eligibility)
    elsif type == 'multi_bid'
      Rules::Basic.new(auction, eligibility)
    end
  end

  private

  attr_reader :auction
  attr_reader :eligibility

  def type
    auction.type
  end
end
