class Admin::NeedsAttentionAuctionsViewModel < Admin::BaseViewModel
  def needs_attention_auctions_nav_class
    'usa-current'
  end

  def drafts
    Auction.unpublished.map { |auction| Admin::DraftListItem.new(auction) }
  end

  def delivery_past_due
    list_items(AuctionQuery.new.delivery_past_due)
  end

  def evaluation_needed
    list_items(AuctionQuery.new.pending_acceptance)
  end

  def payment_needed
    list_items(AuctionQuery.new.payment_needed)
  end

  private

  def list_items(auctions)
    auctions.map { |auction| Admin::NeedsAttentionAuctionListItem.new(auction) }
  end
end
