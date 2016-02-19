class AuctionsController < ApplicationController
  def index
    collection = AuctionQuery.new.public_index
    @view_model = ViewModel::AuctionsIndex.new(current_user, collection)

    respond_to do |format|
      format.html
      format.json do
        render json: @view_model.auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @view_model = ViewModel::AuctionShow.new(current_user, auction)

    respond_to do |format|
      format.html
      format.json do
        render json: @view_model.auction, serializer: AuctionSerializer
      end
    end
  end

  def single_bid_rules
  end

  def multi_bid_rules
  end

  rescue_from 'ActiveRecord::RecordNotFound' do
    respond_to do |format|
      format.html do
        fail ActionController::RoutingError, 'Not Found'
      end
    end
  end
end
