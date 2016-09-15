class AdminAuctionStatusPresenterFactory
  attr_reader :auction

  def initialize(auction:)
    @auction = auction
  end

  def create
    if auction.payment_confirmed? || auction.c2_paid?
      Object.const_get("C2StatusPresenter::#{c2_status}")
    elsif future? && auction.published?
      AdminAuctionStatusPresenter::Future
    elsif work_in_progress?
      AdminAuctionStatusPresenter::WorkInProgress
    elsif !auction.pending_delivery?
      Object.const_get("AdminAuctionStatusPresenter::#{status}")
    else # if auction.purchase_card == 'default'
      Object.const_get("C2StatusPresenter::#{c2_status}")
    end.new(auction: auction)
  end

  private

  def future?
    AuctionStatus.new(auction).future?
  end

  def work_in_progress?
    AuctionStatus.new(auction).work_in_progress?
  end

  def status
    auction.status.camelize
  end

  def c2_status
    auction.c2_status.camelize
  end
end
