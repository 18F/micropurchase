class AuctionsIndexViewModel < Struct.new(:current_user, :auctions_query)
  def auctions
    @auctions ||= auctions_query.map { |auction| AuctionViewModel.new(current_user, auction) }
  end

  def active_auction_count
    auctions.count { |i| i.started_at < Time.now && Time.now < i.ended_at }
  end

  def upcoming_auction_count
    auctions.count { |i| Time.now < i.started_at }
  end

  def auctions_list_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list'
    end
  end

  def auctions_list_previous_partial
    if auctions.empty?
      'empty_auctions'
    else
      'auctions_list_previous'
    end
  end
end
