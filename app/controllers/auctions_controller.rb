class AuctionsController < ApplicationController
  def index
    @auction_collection = AuctionsIndexViewModel.new(
      auctions: AuctionQuery.new.public_index,
      current_user: current_user
    )
    @auctions = paginated_auctions
    @auction_collection.sam_status_message_for(flash)
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @view_model = AuctionShowViewModel.new(auction: auction, current_user: current_user)
  end

  private

  def paginated_auctions
    Kaminari
      .paginate_array(@auction_collection.auction_view_models)
      .page(params[:page]).per(10)
  end
end
