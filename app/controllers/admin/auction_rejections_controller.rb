class Admin::AuctionRejectionsController < Admin::BaseController
  def update
    auction = Auction.find(params[:id])
    auction.update(delivery_status: :rejected, rejected_at: Time.current)
    WinningBidderMailer.auction_rejected(auction: auction).deliver_later
    redirect_to admin_auction_path(auction)
  end
end
