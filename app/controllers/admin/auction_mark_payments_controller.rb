class Admin::AuctionMarkPaymentsController < Admin::BaseController
  def update
    @auction = Auction.find(params[:id])

    paid_auction = MarkPaidAuction.new(
      auction: @auction
    )

    if paid_auction.perform
      @auction.save!
    else
      error_messages = @auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
    end

    redirect_to admin_auction_path(@auction)
  end
end
