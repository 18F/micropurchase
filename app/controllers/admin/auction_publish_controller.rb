class Admin::AuctionPublishController < Admin::BaseController
  def update
    auction = Auction.find(params[:id])
    auction.published = :published
    update_auction = UpdateAuction.new(auction: auction, params: params, current_user: current_user)

    if update_auction.perform
      flash[:success] = I18n.t('controllers.admin.auction_publish.update.success')
    else
      error_messages = auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
    end

    redirect_to admin_auction_path(auction)
  end
end
