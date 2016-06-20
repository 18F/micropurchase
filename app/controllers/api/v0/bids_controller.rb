class Api::V0::BidsController < ApiController
  before_filter :require_authentication, except: [:index]
  skip_before_action :verify_authenticity_token

  def create
    @bid = PlaceBid.new(params: params, bidder: current_user, via: via)

    if @bid.perform
      render json: @bid.bid, serializer: BidSerializer
    else
      render json: { error: @bid.errors.full_messages.to_sentence }, status: 403
    end
  rescue ActiveRecord::RecordNotFound
    handle_error('Auction not found', :not_found)
  end
end
