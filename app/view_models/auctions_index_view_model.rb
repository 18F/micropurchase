class AuctionsIndexViewModel
  attr_reader :auctions, :current_user

  def initialize(auctions:, current_user:)
    @auctions = auctions.to_a
    @current_user = current_user
  end

  def active_auction_count
    auctions.count { |i| i.started_at < Time.current && Time.current < i.ended_at }
  end

  def upcoming_auction_count
    auctions.count { |i| Time.current < i.started_at }
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
