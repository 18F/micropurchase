class Admin::AuctionsController < ApplicationController
  before_filter :require_admin

  def index
    auctions = Auction.all
    @auctions = auctions.map { |auction| Admin::AuctionListItem.new(auction) }

    respond_to do |format|
      format.html
      format.json do
        render json: auctions, each_serializer: Admin::AuctionSerializer
      end
    end
  end

  def show
    auction = Auction.find(params[:id])
    @auction = Admin::AuctionShow.new(auction)

    respond_to do |format|
      format.html
      format.json do
        render json: auction, serializer: Admin::AuctionSerializer
      end
    end
  end

  def preview
    auction = Auction.find(params[:id])
    @auction = AuctionShowViewModel.new(auction: auction, current_user: current_user)
    render 'auctions/show'
  end

  def new
    @auction = Admin::NewAuctionViewModel.new
  end

  def create
    @auction = CreateAuction.new(params, current_user).perform

    if @auction.save
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('controllers.admin.auctions.create.success')
          redirect_to admin_auctions_path
        end
        format.json do
          render json: @auction, serializer: Admin::AuctionSerializer
        end
      end
    else
      error_messages = @auction.errors.full_messages.to_sentence
      respond_to do |format|
        format.html do
          flash[:error] = error_messages
          @auction = Admin::NewAuctionViewModel.new
          render :new
        end
        format.json { render json: { error: error_messages } }
      end
    end
  end

  def edit
    @auction = Admin::EditAuctionViewModel.new(Auction.find(params[:id]))
  end

  def update
    auction = Auction.find(params[:id])
    if UpdateAuction.new(auction, params, current_user).perform
      respond_to do |format|
        format.html { redirect_to admin_auctions_path }
        format.json do
          render json: auction, serializer: Admin::AuctionSerializer
        end
      end
    else
      error_messages = auction.errors.full_messages.to_sentence
      respond_to do |format|
        format.html do
          flash[:error] = error_messages
          @auction = Admin::EditAuctionViewModel.new(auction)
          render :edit
        end
        format.json { render json: { error: error_messages } }
      end
    end
  end
end
