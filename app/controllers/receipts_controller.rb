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
    ConfirmPayment.new(auction).perform

    redirect_to auction_path(auction)
  end

  def show
    auction = Auction.find(params[:auction_id])
    @view_model = AuctionReceiptShowViewModel.new(auction)

    render 'show.text.erb', layout: false, content_type: 'text/plain'
  end
end
