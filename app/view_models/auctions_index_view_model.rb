class AuctionsIndexViewModel
  attr_reader :auctions, :current_user

  def initialize(auctions:, current_user:)
    @auctions = auctions
    @current_user = current_user
  end

  def active_auction_count
    AuctionQuery.new.active_auction_count
  end

  def upcoming_auction_count
    AuctionQuery.new.upcoming_auction_count
  end

  def auction_view_models
    auctions.map do |auction|
      AuctionListItem.new(auction: auction, current_user: current_user)
    end
  end

  def welcome_message_partial
    current_user.decorate.welcome_message_partial
  end

  def auctions_list_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list'
    end
  end
end
