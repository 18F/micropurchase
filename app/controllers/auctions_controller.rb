class AuctionsController < ApplicationController
  def index
    @auctions = Auction.in_reverse_chron_order.with_bids.map {|auction| Presenter::Auction.new(auction) }

    respond_to do |format|
      format.html
      format.json do
        render json: @auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    @auction = Presenter::Auction.new(Auction.find(params[:id]))
  end
end
