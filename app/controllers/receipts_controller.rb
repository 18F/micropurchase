class ReceiptsController < ApplicationController
  before_action :require_authentication

  def new
    auction = Auction.find(params[:auction_id])
    winning_bidder = WinningBid.new(auction).find.try(:bidder)

    if current_user != winning_bidder || auction.paid_at.nil?
      redirect_to root_path
    else
      @view_model = AuctionReceiptViewModel.new(
        auction: auction,
        current_user: current_user
      )
      render 'auctions/show'
    end
  end

  def create
    auction = Auction.find(params[:auction_id])
    auction.update(c2_status: :payment_confirmed)

    redirect_to auction_path(auction)
  end
end
