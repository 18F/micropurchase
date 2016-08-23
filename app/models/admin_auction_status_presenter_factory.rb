class AdminAuctionStatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.pending_acceptance? || auction.rejected?
      Object.const_get("AdminAuctionStatusPresenter::#{status}").new(auction: auction)
    else
      Object.const_get("C2StatusPresenter::#{c2_status}").new(auction: auction)
    end
  end

  private

  def status
    auction.status.camelize
  end

  def c2_status
    auction.c2_status.camelize
  end
end
