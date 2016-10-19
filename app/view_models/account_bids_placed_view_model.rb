class AccountBidsPlacedViewModel
  attr_reader :current_user

  def initialize(current_user:)
    @current_user = current_user
  end

  def bids_table_partial
    if auctions.empty?
      'bids/bids_table_none'
    else
      'bids/bids_table'
    end
  end

  def auctions
    @_auctions ||= AuctionQuery.new.with_bid_from_user(current_user.id).map do |auction|
      UserAuctionViewModel.new(auction, current_user)
    end
  end
end
