class AuctionsController < ApplicationController
  def index
    collection = AuctionQuery.new.public_index
    @auctions = AuctionsIndexViewModel.new(auctions: collection, current_user: current_user)
    sam_status_message_for(flash)

    respond_to do |format|
      format.html
      format.json do
        render json: collection, each_serializer: AuctionSerializer
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

    @view_model = AuctionCollection.new(current_user, collection)

    @auctions_json = @view_model.auctions.each { |a| AuctionSerializer.new(a, root: false) }.as_json
    respond_to do |format|
      format.html
    end
  end

  def previous_winners
    collection = AuctionQuery.new.public_index
    @view_model = AuctionCollection.new(current_user, collection)

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

  private

  def sam_status_message_for(flash)
    user = current_user || Guest.new
    user.decorate.sam_status_message_for_auctions_index(flash)
  end
end
