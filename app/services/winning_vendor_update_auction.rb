class WinningVendorUpdateAuction
  attr_reader :auction, :current_user, :params

  def initialize(auction:, current_user:, params:)
    @auction = auction
    @current_user = current_user
    @params = params
  end

  def perform
    if user_is_winning_bidder? && result.present?
      auction.update(result: :pending_acceptance)
    elsif user_is_winning_bidder? && delivery_url.present?
      auction.update(delivery_url: delivery_url)
    else
      false
    end
  end

  private

  def user_is_winning_bidder?
    winning_bidder.present? && winning_bidder == current_user
  end

  def winning_bidder
    WinningBid.new(auction).find.bidder
  end

  def delivery_url
    params[:auction][:delivery_url]
  end

  def result
    params[:auction][:result]
  end
end
