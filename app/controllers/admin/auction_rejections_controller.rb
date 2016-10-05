class Admin::AuctionRejectionsController < Admin::BaseController
  def update
    auction = Auction.find(params[:id])
    RejectAuction.new(auction: auction).perform
    redirect_to admin_auction_path(auction)
  end
end
