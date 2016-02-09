class AuctionsController < ApplicationController
  def index
    @view_model = ViewModel::AuctionsIndex.new(current_user, Auction.in_reverse_chron_order.with_bids)

    respond_to do |format|
      format.html
      format.json do
        render json: @view_model.auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    @auction = Presenter::Auction.new(Auction.find(params[:id]))

    respond_to do |format|
      format.html
      format.json do
        render json: @auction, serializer: AuctionSerializer
      end
    end
  end
end
