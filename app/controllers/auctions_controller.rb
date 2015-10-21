class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all.includes(:bids).map{|auction| Presenter::Auction.new(auction) }
  end
end
