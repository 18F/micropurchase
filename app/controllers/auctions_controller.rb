class AuctionsController < ApplicationController
  def index
    @auction_collection = AuctionsIndexViewModel.new(
      auctions: AuctionQuery.new.public_index,
      current_user: current_user
    )

    @auction_collection.sam_status_message_for(flash)
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @auction = AuctionShowViewModel.new(auction: auction, current_user: current_user)
  end
end
