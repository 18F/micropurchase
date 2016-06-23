class BidConfirmationsController < ApplicationController
  before_filter :require_authentication

  def create
    bid = PlaceBid.new(params: params, bidder: current_user, via: via)
    auction = AuctionQuery.new.public_find(params[:auction_id])

    if bid.valid?
      readonly_bid = bid.dry_run
      @confirm_bid = ConfirmBidViewModel.new(auction: auction, bid: readonly_bid)
    else
      flash[:error] = bid.errors.full_messages.to_sentence
      redirect_to auction_path(auction)
    end
  end
end
