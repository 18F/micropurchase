class Admin::MissedDeliveriesController < Admin::BaseController
  def update
    @auction = Auction.find(params[:id])

    missed_delivery = MarkAuctionDeliveryMissed.new(
      auction: @auction
    )

    if missed_delivery.perform
      @auction.save!
    else
      error_messages = @auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
    end

    redirect_to admin_auction_path(@auction)
  end
end
