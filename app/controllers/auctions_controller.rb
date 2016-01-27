class AuctionsController < ApplicationController
  def index
    @auctions = Auction.in_reverse_chron_order.with_bids.map {|auction| Presenter::Auction.new(auction) }
  end

  def show
    @auction = Presenter::Auction.new(Auction.find(params[:id]))
  end
end
