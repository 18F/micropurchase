class Admin::AuctionsIndexViewModel < Admin::BaseViewModel
  attr_reader :auctions

  def initialize(auctions: Auction.all.order(started_at: :desc))
    @auctions = auctions
  end

  def auction_view_models
    auctions.map do |auction|
      Admin::AuctionListItem.new(auction: auction)
    end
  end

  def auctions_nav_class
    'usa-current'
  end
end
