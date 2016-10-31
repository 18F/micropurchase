class Admin::AuctionMarkPaymentsController < Admin::BaseController
  def update
    @auction = Auction.find(params[:id])

    paid_auction = MarkAuctionAsPaid.new(
      auction: @auction
    )

    if paid_auction.perform
      flash[:success] = I18n.t('controllers.admin.auction_mark_payments.update.success')
      @auction.save!
    else
      error_messages = @auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
    end

    redirect_to admin_auction_path(@auction)
  end
end
