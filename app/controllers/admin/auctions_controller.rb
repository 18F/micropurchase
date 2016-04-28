module Admin
  class AuctionsController < ApplicationController
    before_filter :require_admin

    def index
      @auctions = Auction.all.map { |auction| Presenter::AdminAuction.new(auction) }

      respond_to do |format|
        format.html
        format.json do
          render json: @auctions, each_serializer: Admin::AuctionSerializer
        end
      end
    end

    def show
      @auction = Presenter::AdminAuction.new(Auction.find(params[:id]))

      respond_to do |format|
        format.html
        format.json do
          render json: @auction, serializer: Admin::AuctionSerializer
        end
      end
    end

    def preview
      auction = Auction.find(params[:id])
      @view_model = ViewModel::AuctionShow.new(current_user, auction)

      render 'auctions/show'
    end

    def new
      if params[:auction]
        parser = AuctionParser.new(params)
        auction = Auction.new(parser.general_attributes)
      else
        auction = Auction.new
      end
      # @view_model = ViewModel::AdminAuctionForm.new(auction)
      @auction = Presenter::AdminAuction.new(auction)
    end

    def create
      auction = CreateAuction.new(params).perform
      auction = Presenter::AdminAuction.new(auction)

      respond_to do |format|
        format.html { redirect_to "/admin/auctions" }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
        end
      end
    rescue ArgumentError => e
      respond_error(e)
    end

    def update
      auction = Auction.find(params[:id])
      UpdateAuction.new(auction, params).perform
      auction.reload
      auction = Presenter::AdminAuction.new(auction)

      respond_to do |format|
        format.html { redirect_to "/admin/auctions" }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
exit        end
      end
    rescue ArgumentError => e
      respond_error(e)
    end

    def edit
      auction = Auction.find(params[:id])
      @auction = Presenter::AdminAuction.new(auction)
    end

    private

    def respond_error(exception)
      message = exception.message

      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to "/admin/auctions"
        end
        format.json do
          render json: { error: message }
        end
      end
    end
  end
end
