class BidsController < ApplicationController
  before_filter :require_authentication

  def create
    @bid = PlaceBid.new(params: params, bidder: current_user, via: via)

    if @bid.perform
      flash[:bid] = "success"
    else
      flash[:bid_error] = @bid.errors.full_messages.to_sentence
    end

    redirect_to auction_path(@bid.auction)
  end

  def index
    @view_model = AccountBidsPlacedViewModel.new(current_user: current_user)
  end
end
