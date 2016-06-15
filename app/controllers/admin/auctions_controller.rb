class Admin::AuctionsController < ApplicationController
  before_filter :require_admin

  def index
    @auctions = Auction.all.map { |auction| Admin::AuctionListItem.new(auction) }
  end

  def show
    @auction = Admin::AuctionShowViewModel.new(Auction.find(params[:id]))
  end

  def preview
    auction = Auction.find(params[:id])
    @auction = ::AuctionShowViewModel.new(auction: auction, current_user: current_user)
    render 'auctions/show'
  end

  def new
    @auction = Admin::NewAuctionViewModel.new
  end

  def create
    @auction = CreateAuction.new(params, current_user).perform

    if @auction.save
      flash[:success] = I18n.t('controllers.admin.auctions.create.success')
      redirect_to admin_auctions_path
    else
      error_messages = @auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
      @auction = Admin::NewAuctionViewModel.new
      render :new
    end
  end

  def edit
    @auction = Admin::EditAuctionViewModel.new(Auction.find(params[:id]))
    session[:return_to] = request.referer
  end

  def update
    auction = Auction.find(params[:id])
    update_auction = UpdateAuction.new(auction, params)

    if update_auction.perform
      redirect_to(session[:return_to] || admin_auctions_path)
      session[:return_to] = nil
    else
      error_messages = auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
      @auction = Admin::EditAuctionViewModel.new(auction)
      render :edit
    end
  end
end
