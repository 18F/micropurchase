class AuctionsController < ApplicationController
  def index
    @auction_collection = AuctionsIndexViewModel.new(
      auctions: published_auctions,
      current_user: current_user
    )

    respond_to do |format|
      format.html do
        @auction_collection.sam_status_message_for(flash)
      end
      format.json do
        render json: published_auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @auction = AuctionShowViewModel.new(auction: auction, current_user: current_user)

    respond_to do |format|
      format.html
      format.json do
        render json: auction, serializer: AuctionSerializer
      end
    end
  end

  def previous_winners
    @auctions = PreviousWinnersViewModel.new
  end

  private

  def published_auctions
    @_published_auctions ||= AuctionQuery.new.public_index
  end
end
