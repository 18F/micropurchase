class AuctionsIndexViewModel
  attr_reader :auctions, :current_user

  def initialize(auctions:, current_user:)
    @auctions = auctions
    @current_user = current_user
  end

  def active_auction_count
    auctions
      .where('started_at < ?', Time.current)
      .where('ended_at > ?', Time.current)
      .count
  end

  def upcoming_auction_count
    auctions.where('started_at > ?', Time.current).count
  end

  def auction_view_models
    auctions.map do |auction|
      AuctionListItem.new(auction: auction, current_user: current_user)
    end
  end

  def auctions_list_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list'
    end
  end
end
