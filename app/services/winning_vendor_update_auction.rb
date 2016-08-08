class WinningVendorUpdateAuction
  attr_reader :auction, :current_user, :params

  def initialize(auction:, current_user:, params:)
    @auction = auction
    @current_user = current_user
    @params = params
  end

  def perform
    if winning_bidder.present? &&
       winning_bidder == current_user &&
       delivery_url.present?
      auction.update(delivery_url: delivery_url)
    else
      false
    end
  end

  private

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def delivery_url
    params[:auction][:delivery_url]
  end
end
