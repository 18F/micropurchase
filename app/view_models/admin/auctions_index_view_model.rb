class Admin::AuctionsIndexViewModel < Admin::BaseViewModel
  def auctions
    Auction.all.order(started_at: :desc).map do |auction|
      Admin::AuctionListItem.new(auction: auction)
    end
  end

  def auctions_nav_class
    'usa-current'
  end
end
