class Api::V0::AuctionsController < ApiController
  def index
    render json: AuctionQuery.new.public_index, each_serializer: AuctionSerializer
  end

  def show
    render json: AuctionQuery.new.public_find(params[:id]), serializer: AuctionSerializer
  rescue ActiveRecord::RecordNotFound => ex
    handle_error(ex.message)
  end
end
