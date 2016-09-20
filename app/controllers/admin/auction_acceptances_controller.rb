class Admin::AuctionAcceptancesController < Admin::BaseController
  def update
    @auction = Auction.find(params[:id])

    accept_auction = AcceptAuction.new(
      auction: @auction,
      payment_url: winning_bidder.payment_url
    )

    if accept_auction.perform
      @auction.save!
    else
      error_messages = @auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
    end

    redirect_to admin_auction_path(@auction)
  end

  private

  def winning_bidder
    WinningBid.new(@auction).find.bidder
  end
end
