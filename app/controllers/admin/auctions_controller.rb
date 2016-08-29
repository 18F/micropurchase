class Admin::AuctionsController < ApplicationController
  layout 'admin', except: [:preview]
  before_action :require_admin, except: [:show]

  def index
    @view_model = Admin::AuctionsIndexViewModel.new
    @auctions = paginated_auctions
  end

  def show
    @view_model = Admin::AuctionShowViewModel.new(
      auction: Auction.find(params[:id]),
      current_user: current_user
    )
  end

  def preview
    auction = Auction.find(params[:id])
    @view_model = ::AuctionShowViewModel.new(auction: auction, current_user: current_user)
    render 'auctions/show'
  end

  def new
    @view_model = Admin::NewAuctionViewModel.new
  end

  def create
    auction = BuildAuction.new(params, current_user).perform

    if SaveAuction.new(auction).perform
      flash[:success] = I18n.t('controllers.admin.auctions.create.success')
      redirect_to admin_auctions_path
    else
      flash.now[:error] = auction.errors.full_messages.to_sentence
      @view_model = Admin::NewAuctionViewModel.new(auction)
      render :new
    end
  end

  def edit
    store_referer
    @view_model = Admin::EditAuctionViewModel.new(Auction.find(params[:id]))
  end

  def update
    auction = Auction.find(params[:id])
    update_auction = UpdateAuction.new(auction: auction, params: params, current_user: current_user)

    if update_auction.perform
      flash[:success] = I18n.t('controllers.admin.auctions.update.success')
      return_to_stored(default: admin_auction_path(auction))
    else
      error_messages = auction.errors.full_messages.to_sentence
      flash.now[:error] = error_messages
      @view_model = Admin::EditAuctionViewModel.new(auction)
      render :edit
    end
  end

  private

  def paginated_auctions
    Kaminari
      .paginate_array(@view_model.auction_view_models)
      .page(params[:page]).per(10)
  end

  def user_can_view_auction?(auction)
    if current_user.is_a?(GuestWithToken)
      current_user.auction == auction
    else
      current_user.admin?
    end
  end
end
