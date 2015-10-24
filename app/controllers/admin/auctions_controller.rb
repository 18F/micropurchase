module Admin
  class AuctionsController < ApplicationController
    before_filter :require_admin

    def index
      @auctions = Auction.all.map{|auction| Presenter::Auction.new(auction) }
    end

    def show
      @auction = Presenter::Auction.new(Auction.find(params[:id]))
    end
  end
end
