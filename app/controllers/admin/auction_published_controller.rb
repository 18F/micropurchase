class Admin::AuctionPublishedController < Admin::BaseController
  def update
    auction = Auction.find(params[:id])

    if auction.update(published: :unpublished)
      flash[:success] = I18n.t(
        'controllers.admin.auctions.unpublish.success',
        title: auction.title
      )
      redirect_to admin_auction_path(auction)
    end
  end
end
