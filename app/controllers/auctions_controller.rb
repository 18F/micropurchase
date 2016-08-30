class AuctionsController < ApplicationController
  before_action :require_authentication, only: [:update]

  def index
    @auction_collection = AuctionsIndexViewModel.new(
      auctions: AuctionQuery.new.public_index,
      current_user: current_user
    )
    @auctions = paginated_auctions
    @auction_collection.sam_status_message_for(flash)
  end

  def show
    auction = find_auction
    @view_model = AuctionShowViewModel.new(auction: auction, current_user: current_user)
  end

  def update
    auction = Auction.find(params[:id])
    updater = WinningVendorUpdateAuction.new(
      auction: auction,
      current_user: current_user,
      params: params
    )

    unless updater.perform
      flash[:error] = I18n.t('errors.update_auction.delivery_url')
    end

    redirect_to auction_path(auction)
  end

  private

  def find_auction
    if params[:token]
      Auction.find_by(token: params[:token])
    else
      AuctionQuery.new.public_find(params[:id])
    end
  end

  def paginated_auctions
    Kaminari
      .paginate_array(@auction_collection.auction_view_models)
      .page(params[:page]).per(10)
  end
end
