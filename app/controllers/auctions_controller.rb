class AuctionsController < ApplicationController
  def index
    @auctions = AuctionsIndexViewModel.new(
      auctions: published_auctions,
      current_user: current_user
    )

    respond_to do |format|
      format.html do
        sam_status_message_for(flash)
      end
      format.json do
        render json: published_auctions, each_serializer: AuctionSerializer
      end
    end
  end

  def show
    auction = AuctionQuery.new.public_find(params[:id])
    @view_model = AuctionShowViewModel.new(current_user, auction)

    respond_to do |format|
      format.html
      format.json do
        render json: auction, serializer: AuctionSerializer
      end
    end
  end

  def previous_winners
    @auctions = PreviousWinnersViewModel.new
  end

  private

  def published_auctions
    @_published_auctions ||= AuctionQuery.new.public_index
  end

  def sam_status_message_for(flash)
    current_user.decorate.sam_status_message_for_auctions_index(flash)
  end
end
