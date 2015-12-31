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
      CreateAuction.new(params).perform
      redirect_to "/admin/auctions"
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect_to "/admin/auctions" # render edit
    end

    def destroy
      auction = Auction.find(params[:id])
      DestroyAuction.new(auction).perform
      redirect_to "/admin/auctions"
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect_to "/admin/auctions"
    end

    def update
      auction = Auction.find(params[:id])
      UpdateAuction.new(auction, params).perform
      redirect_to "/admin/auctions"
    rescue ArgumentError => e
      flash[:error] = e.message
      redirect_to "/admin/auctions"
    end

    def edit
      @auction = Auction.find(params[:id])
    end
  end
end
