class BidsController < ApplicationController
  before_filter :require_authentication, except: [:index]

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

  def create
    fail UnauthorizedError, "You must have a valid SAM.gov account to place a bid" unless current_user.sam_account?
    PlaceBid.new(params, current_user).perform
    flash[:bid] = "success"
    redirect_to "/auctions/#{params[:auction_id]}"
  rescue UnauthorizedError => e
    flash[:error] = e.message
    redirect_to "/auctions/#{params[:auction_id]}/bids/new"
  end
end
