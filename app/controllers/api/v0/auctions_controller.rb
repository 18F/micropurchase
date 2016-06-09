class Api::V0::AuctionsController < ApplicationController
  def index
    render json: AuctionQuery.new.public_index, each_serializer: AuctionSerializer
  end

  def show
    render json: AuctionQuery.new.public_find(params[:id]), serializer: AuctionSerializer
  end
end
