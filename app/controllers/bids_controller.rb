class BidsController < ApplicationController
  before_filter :require_authentication, except: [:index]
  skip_before_action :verify_authenticity_token, if: :api_request?

  def index
    @auction = Presenter::Auction.new(
      Auction.includes(:bids, :bidders).find(params[:auction_id])
    )
  end

  def my_bids
    @auctions = Auction.
                joins(:bids).
                where(bids: {bidder_id: current_user.id}).
                uniq.
                map {|auction| Presenter::Auction.new(auction) }
  end

  def new
    # check if user is valid
    if current_user.sam_account?
      @auction = Presenter::Auction.new(Auction.find(params[:auction_id]))
      @bid = Bid.new
    else
      session[:return_to] = request.fullpath
      redirect_to edit_user_path(current_user)
    end
  end

  def confirm
    @auction = Presenter::Auction.new(Auction.find(params[:auction_id]))
    @bid = Presenter::Bid.new(PlaceBid.new(params, current_user).dry_run)
  end

  def create
    begin
      fail UnauthorizedError, "You must have a valid SAM.gov account to place a bid" unless current_user.sam_account?
      @bid = Presenter::Bid.new(PlaceBid.new(params, current_user).perform)

      respond_to do |format|
        format.html do
          flash[:bid] = "success"
          redirect_to "/auctions/#{params[:auction_id]}"
        end
        format.json do
          render json: @bid, serializer: BidSerializer
        end
      end
    rescue UnauthorizedError => e
      respond_error(e, redirect_path: "/auctions/#{params[:auction_id]}/bids/new")
    end
  end

  private

  def respond_error(error, redirect_path: '/')
    respond_to do |format|
      format.html do
        flash[:error] = error.message
        redirect_to redirect_path
      end
      format.json do
        render json: {error: error.message}, status: 403
      end
    end
  end
end
