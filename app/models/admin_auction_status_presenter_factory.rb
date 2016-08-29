class AdminAuctionStatusPresenterFactory
  attr_reader :auction, :current_user

  def initialize(auction:, current_user:)
    @auction = auction
    @current_user = current_user
  end

  def create
    # hmmmm, seems inelegant
    return AdminAuctionStatusPresenter::GuestWithToken.new(auction: auction) if current_user.is_a?(GuestWithToken)

    if auction.payment_confirmed? || auction.c2_paid?
      Object.const_get("C2StatusPresenter::#{c2_status}").new(auction: auction)
    elsif !auction.pending_delivery?
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
