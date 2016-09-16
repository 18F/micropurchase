class Admin::AuctionAcceptancesController < Admin::BaseController
  def update
    @auction = Auction.find(params[:id])

    AcceptAuction.new(
      auction: @auction,
      payment_url: winning_bidder.payment_url
    ).perform

    @auction.save!
    redirect_to admin_auction_path(@auction)
  end

  private

  def winning_bidder
    WinningBid.new(@auction).find.bidder
  end
end
