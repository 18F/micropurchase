class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all.includes(:bids).map {|auction| Presenter::Auction.new(auction) }
  end

  def show
    @auction = Presenter::Auction.new(Auction.find(params[:id]))
  end
end
