class ReceiptsController < ApplicationController
  before_action :require_authentication

  def new
    auction = Auction.find(params[:auction_id])
    winning_bidder = WinningBid.new(auction).find.try(:bidder)

    if current_user != winning_bidder || auction.paid_at.nil?
      redirect_to root_path
    end
  end
end
