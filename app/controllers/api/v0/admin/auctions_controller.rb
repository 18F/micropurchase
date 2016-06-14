class Api::V0::Admin::AuctionsController < ApiController
  before_filter :require_admin

  def index
    render json: Auction.all, each_serializer: Admin::AuctionSerializer
  end

  def show
    auction = Auction.find(params[:id])
    render json: auction, serializer: Admin::AuctionSerializer
  end
end
