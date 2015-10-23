class BidsController < ApplicationController
  def index
    require_authentication and return
    @auctions = Auction
      .joins(:bids)
      .where(bids: {bidder_id: current_user.id})
      .uniq
      .map {|auction| Presenter::Auction.new(auction) }
  end

  def new
    @auction = Presenter::Auction.new(Auction.find(params[:auction_id]))
    @bid = Bid.new
  end

  def create
    require_authentication and return
    PlaceBid.new(params, current_user).perform
    redirect_to "/auctions/#{params[:auction_id]}/bids/new"
  rescue UnauthorizedError => e
    flash[:error] = e.message
    redirect_to "/auctions/#{params[:auction_id]}/bids/new"
  end
end
