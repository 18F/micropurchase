class Admin::DraftAuctionsViewModel < Admin::BaseViewModel
  def auctions
    unpublished_auctions.map { |auction| Admin::DraftListItem.new(auction) }
  end

  def drafts_nav_class
    'usa-current'
  end

  private

  def unpublished_auctions
    Auction.unpublished
  end
end
