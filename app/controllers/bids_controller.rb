class BidsController < ApplicationController
  before_filter :require_authentication

  def index
    bids = Bid.where(bidder: current_user).includes(:auction)
    @bids = bids.map { |bid| MyBidListItem.new(bid) }
  end

  def create
    @bid = PlaceBid.new(params: params, bidder: current_user, via: via)

    if @bid.perform
      flash[:bid] = "success"
    else
      flash[:error] = @bid.errors.full_messages.to_sentence
    end

    redirect_to auction_path(@bid.auction)
  end
end
