module Admin
  class AuctionsController < ApplicationController
    before_filter :require_admin

    def index
      @auctions = Auction.all.map{|auction| Presenter::Auction.new(auction) }
    end

    def show
      @auction = Presenter::Auction.new(Auction.find(params[:id]))
    end

    def new
      @auction = Auction.new
    end

    def create
      AdminCreateAuction.new(params).perform
      redirect_to "/admin/auctions"
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect_to "/admin/auctions" # render edit
    end
  end
end
