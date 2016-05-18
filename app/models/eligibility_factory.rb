class EligibilityFactory
  attr_reader :auction

  def initialize(auction)
    @auction = AuctionPresenter.new(auction)
  end

  def create
    if auction.small_business?
      SmallBusinessEligibility.new
    else
      InSamEligibility.new
    end
  end
end
