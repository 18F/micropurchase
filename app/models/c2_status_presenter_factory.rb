class C2StatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    Object.const_get("C2StatusPresenter::#{c2_status}").new(auction: auction)
  end

  private

  def c2_status
    auction.c2_status.camelize
  end
end
