class Admin::AuctionsIndexViewModel < Admin::BaseViewModel
  def auctions
    Auction.all.map { |auction| Admin::AuctionListItem.new(auction) }
  end

  def auctions_nav_class
    'usa-current'
  end
end
