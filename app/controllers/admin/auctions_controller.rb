module Admin
  class AuctionsController < ApplicationController
    before_filter :require_admin

    def index
      @auctions = Auction.all.map {|auction| Presenter::AdminAuction.new(auction) }

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
      auction = Auction.new

      @auction = Presenter::AdminAuction.new(auction)
    end

    def create
      auction = CreateAuction.new(auction_params).perform
      auction = Presenter::AdminAuction.new(auction)

      respond_to do |format|
        format.html { redirect_to admin_auctions_path }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
        end
      end
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

    def auction_params
      params.require(:auction).permit(
        :awardee_paid_status,
        :billable_to,
        :cap_proposal_url,
        :delivery_deadline,
        :delivery_url,
        :description,
        :due_in_days,
        :end_datetime,
        :github_repo,
        :issue_url,
        :notes,
        :published,
        :result,
        :start_datetime,
        :start_price,
        :summary,
        :title,
        :type,
      )
    end

    def respond_error(exception)
      message = exception.message

      respond_to do |format|
        format.html do
          flash[:error] = message
          redirect_to "/admin/auctions"
        end
        format.json do
          render json: {error: message}
        end
      end
    end
  end
end
