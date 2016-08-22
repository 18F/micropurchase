class C2StatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.pending_acceptance?
      AdminAuctionStatusPresenter::PendingAcceptance.new(auction: auction)
    else
      Object.const_get("C2StatusPresenter::#{c2_status}").new(auction: auction)
    end
  end

  private

  def c2_status
    auction.c2_status.camelize
  end
end
