class AuctionsIndexViewModel < Struct.new(:current_user, :auctions_query)
  def auctions
    @auctions ||= auctions_query.map { |auction| AuctionViewModel.new(current_user, auction) }
  end

  def active_auction_count
    auctions.count { |i| i.start_datetime < Time.now && Time.now < i.end_datetime }
  end

  def upcoming_auction_count
    auctions.count { |i| Time.now < i.start_datetime }
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
