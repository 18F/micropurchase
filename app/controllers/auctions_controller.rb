class AuctionsController < ApplicationController
  def index
    @auctions = AuctionQuery.new.public_index
    @view_model = AuctionsIndexViewModel.new(user: current_user, auctions: @auctions)

    respond_to do |format|
      format.html
      format.json do
        render json: @auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    @auction = AuctionQuery.new.public_find(params[:id])
    @view_model = AuctionShowViewModel.new(user: current_user, auction: @auction)

    respond_to do |format|
      format.html
      format.json do
        render json: @auction, serializer: AuctionSerializer
      end
    end
  end

  def previous_winners_archive
    @auctions = AuctionQuery.new.public_index

    if params[:result] == 'true'
      @auctions = @auctions.all.where.not(result: 'rejected')
    elsif params[:result] == 'false'
      @auctions = @auctions.all.where(result: 'rejected')
    end

    @view_model = AuctionsIndexViewModel.new(user: current_user, auctions: @auctions)

    respond_to do |format|
      format.html
    end
  end

  def previous_winners
    @auctions = AuctionQuery.new.public_index
    @view_model = AuctionsIndexViewModel.new(user: current_user, auctions: @auctions)

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
