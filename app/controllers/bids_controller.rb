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

  end

  def create
    
  end
end
