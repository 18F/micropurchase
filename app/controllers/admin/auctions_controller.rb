module Admin
  class AuctionsController < ApplicationController
    before_filter :require_admin

    def index
      @auctions = Auction.all.map {|auction| Presenter::Auction.new(auction) }

      respond_to do |format|
        format.html
        format.json do
          render json: @auctions, each_serializer: Admin::AuctionSerializer
        end
      end
    end

    def show
      @auction = Presenter::Auction.new(Auction.find(params[:id]))

      respond_to do |format|
        format.html
        format.json do
          render json: @auction, serializer: Admin::AuctionSerializer
        end
      end
    end

    def new
      @auction = Auction.new
    end

    def create
      auction = CreateAuction.new(params).perform
      auction = Presenter::Auction.new(auction)

      respond_to do |format|
        format.html { redirect_to "/admin/auctions" }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
        end
      end
    rescue ArgumentError => e
      respond_to do |format|
        message = e.message

        format.html do
          flash[:error] = message
          redirect_to "/admin/auctions" # render edit
        end
        format.json do
          render json: {error: message}
        end
      end
    end

    def destroy
      id = params[:id].dup
      auction = Auction.find(id)
      DestroyAuction.new(auction).perform

      respond_to do |format|
        format.html { redirect_to "/admin/auctions" }
        format.json do
          render json: {message: "Successfully deleted Auction ##{id}"}
        end
      end
    rescue ArgumentError => e
      message = e.message

      respond_to do |format|
        format.html do
          flash[:error] = e.message
          redirect_to "/admin/auctions"
        end
        format.json do
          render json: {error: message}
        end
      end
    end

    def update
      auction = Auction.find(params[:id])
      UpdateAuction.new(auction, params).perform
      auction.reload
      auction = Presenter::Auction.new(auction)

      respond_to do |format|
        format.html { redirect_to "/admin/auctions" }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
        end
      end
    rescue ArgumentError => e
      message = e.message

      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to "/admin/auctions"
        end
        format.html do
          render json: {error: message}
        end
      end
    end

    def edit
      @auction = Auction.find(params[:id])
    end
  end
end
