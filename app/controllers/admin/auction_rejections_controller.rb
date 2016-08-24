class Admin::AuctionRejectionsController < Admin::BaseController
  def update
    auction = Auction.find(params[:id])
    auction.update(status: :rejected, rejected_at: Time.current)
    redirect_to admin_auction_path(auction)
  end
end
