class RulesFactory
  def initialize(auction)
    @auction = auction
  end

  def create
    eligibility = if auction.small_business?
                    Eligibility::SmallBusiness.new
                  else
                    Eligibility::InSam.new
                  end

    if type == 'single_bid'
      Rules::SealedBid.new(auction, eligibility)
    elsif type == 'multi_bid'
      Rules::Basic.new(auction, eligibility)
    end
  end

  private

  attr_reader :auction

  def type
    auction.type
  end
end
