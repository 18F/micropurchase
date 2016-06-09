class Api::V0::BidsController < ApplicationController
  before_filter :require_authentication, except: [:index]
  skip_before_action :verify_authenticity_token

  def index
    auction = AuctionQuery.new.bids_index(params[:auction_id])
    @auction_bids = BidsIndexViewModel.new(auction: auction, current_user: current_user)
  end

  def create
    @bid = PlaceBid.new(params: params, bidder: current_user, via: via)

    if @bid.perform
      render json: @bid.bid, serializer: BidSerializer
    else
      render json: { error: @bid.errors.full_messages.to_sentence }, status: 403
    end
  end
end
