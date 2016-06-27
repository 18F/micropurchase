class Admin::AuctionsController < Admin::BaseController
  layout 'admin', except: [:preview]

  def index
    @view_model = Admin::AuctionsIndexViewModel.new
  end

  def show
    @view_model = Admin::AuctionShowViewModel.new(Auction.find(params[:id]))
  end

  def preview
    auction = Auction.find(params[:id])
    @auction = ::AuctionShowViewModel.new(auction: auction, current_user: current_user)
    render 'auctions/show'
  end

  def new
    @view_model = Admin::NewAuctionViewModel.new
  end

  def create
    auction = CreateAuction.new(params, current_user).perform

    if auction.save
      flash[:success] = I18n.t('controllers.admin.auctions.create.success')
      redirect_to admin_auctions_path
    else
      error_messages = auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
      @view_model = Admin::NewAuctionViewModel.new
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
      return_to_stored(default: admin_auction_path(auction))
    else
      error_messages = auction.errors.full_messages.to_sentence
      flash[:error] = error_messages
      @view_model = Admin::EditAuctionViewModel.new(auction)
      render :edit
    end
  end
end
