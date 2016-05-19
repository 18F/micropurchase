class Admin::AuctionsController < ApplicationController
  before_filter :require_admin

  def index
    @auctions = Auction.all.map { |auction| AdminAuctionPresenter.new(auction) }

    respond_to do |format|
      format.html
      format.json do
        render json: @auctions, each_serializer: Admin::AuctionSerializer
      end
    end
  end

  def show
    @auction = AdminAuctionPresenter.new(Auction.find(params[:id]))

    respond_to do |format|
      format.html
      format.json do
        render json: @auction, serializer: Admin::AuctionSerializer
      end
    end
  end

  def preview
    auction = Auction.find(params[:id])
    @view_model = AuctionShowViewModel.new(current_user, auction)
    render 'auctions/show'
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = CreateAuction.new(params, current_user).auction

    if @auction.save
      respond_to do |format|
        format.html do
          flash[:success] = I18n.t('controllers.admin.auctions.create.success')
          redirect_to admin_auctions_path
        end

        format.json do
          render(
            json: AdminAuctionPresenter.new(@auction),
            serializer: Admin::AuctionSerializer
          )
        end
      end
    else
      render_errors(@auction.errors.full_messages.to_sentence, :new)
    end
  end

  def update
    auction = Auction.find(params[:id])
    UpdateAuction.new(auction, params, current_user).perform
    auction.reload

    respond_to do |format|
      format.html { redirect_to admin_auctions_path }
      format.json do
        render(
          json: AdminAuctionPresenter.new(auction),
          serializer: Admin::AuctionSerializer
        )
      end
    end
  rescue ArgumentError => e
    respond_error(e, :edit)
  end

  def edit
    @auction = Auction.find(params[:id])
  end

  private

  def respond_error(exception, path)
    message = exception.message
    render_errors(message, path)
  end

  def render_errors(error_message, path)
    respond_to do |format|
      format.html do
        flash[:error] = error_message
        render path
      end

      format.json do
        render json: { error: error_message }
      end
    end
  end
end
