class EligibilityFactory
  attr_reader :start_price_threshold

  def initialize(auction)
    @start_price_threshold = AuctionThreshold.new(auction)
  end

  def create
    if start_price_threshold.small_business?
      SmallBusinessEligibility.new
    else
      InSamEligibility.new
    end
  end
end
