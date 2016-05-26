class BidsController < ApplicationController
  before_filter :require_authentication, except: [:index]
  skip_before_action :verify_authenticity_token, if: :api_request?

  def index
    auction = AuctionQuery.new.bids_index(params[:auction_id])
    @auction_bids = BidsIndexViewModel.new(auction: auction, current_user: current_user)
  end

  def my_bids
    bids = Bid.where(bidder: current_user).includes(:auction)
    @bids = bids.map { |bid| MyBidListItem.new(bid) }
  end

  def new
    if current_user.sam_accepted?
      auction = AuctionQuery.new.public_find(params[:auction_id])
      @bid_view_model = NewBidViewModel.new(auction: auction, current_user: current_user)
    else
      session[:return_to] = request.fullpath
      redirect_to users_edit_path
    end
  end

  def confirm
    bid = PlaceBid.new(params: params, user: current_user, via: via).dry_run
    @confirm_bid = ConfirmBidViewModel.new(auction: Auction.find(params[:auction_id]), bid: bid)
  end

  def create
    unless current_user.sam_accepted?
      fail UnauthorizedError, "You must have a valid SAM.gov account to place a bid"
    end

    @bid = PlaceBid.new(params: params, user: current_user, via: via).perform

    respond_to do |format|
      format.html do
        flash[:bid] = "success"
        redirect_to auction_path(@bid.auction)
      end
      format.json do
        render json: @bid, serializer: BidSerializer
      end
    end
  rescue UnauthorizedError => e
    respond_error(e, redirect_path: new_auction_bid_path(params[:auction_id]))
  end

  rescue_from 'ActiveRecord::RecordNotFound' do
    respond_to do |format|
      format.html do
        fail ActionController::RoutingError, 'Not Found'
      end
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
        render json: { error: error.message }, status: 403
      end
    end
  end
end
