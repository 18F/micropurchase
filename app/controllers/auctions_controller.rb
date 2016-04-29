class AuctionsController < ApplicationController
  def index
    collection = AuctionQuery.new.public_index
    @view_model = AuctionsIndexViewModel.new(current_user, collection)

    respond_to do |format|
      format.html
      format.json do
        render json: @view_model.auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @view_model = AuctionShowViewModel.new(current_user, auction)

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

  def previous_winners_archive
    collection = AuctionQuery.new.public_index

    if params[:result] == 'true'
      collection = collection.all.where.not(result: 'rejected')
    elsif params[:result] == 'false'
      collection = collection.all.where(result: 'rejected')
    end

    @view_model = AuctionsIndexViewModel.new(current_user, collection)

    @auctions_json = @view_model.auctions.each { |a| AuctionSerializer.new(a, root: false) }.as_json
    respond_to do |format|
      format.html
    end
  end

  def previous_winners
    collection = AuctionQuery.new.public_index
    @view_model = AuctionsIndexViewModel.new(current_user, collection)

    @auctions_json = @view_model.auctions.each { |a| AuctionSerializer.new(a, root: false) }.as_json

    respond_to do |format|
      format.html
    end
  end

  rescue_from 'ActiveRecord::RecordNotFound' do
    respond_to do |format|
      format.html do
        fail ActionController::RoutingError, 'Not Found'
      end
    end
  end
end
