class Admin::NeedsAttentionAuctionsViewModel < Admin::BaseViewModel
  def needs_attention_auctions_nav_class
    'usa-current'
  end

  def drafts_partial
    if drafts.any?
      'draft'
    else
      'null_drafts'
    end
  end

  def drafts
    @_drafts ||= Auction.unpublished.map do |auction|
      Admin::DraftListItem.new(auction)
    end
  end

  def pending_delivery_partial
    if pending_delivery.any?
      'pending_delivery'
    else
      'null_pending_delivery'
    end
  end

  def pending_delivery
    @_pending_delivery ||= list_items(AuctionQuery.new.pending_delivery)
  end

  def evaluation_needed_partial
    if evaluation_needed.any?
      'evaluation_needed'
    else
      'null_evaluation_needed'
    end
  end

  def evaluation_needed
    @_evaluation_needed ||= list_items(Auction.pending_acceptance)
  end

  def payment_needed_partial
    if payment_needed.any?
      'payment_needed'
    else
      'null_payment_needed'
    end
  end

  def payment_needed
    @_payment_needed ||= list_items(AuctionQuery.new.payment_needed)
  end

  private

  def list_items(auctions)
    auctions.map { |auction| Admin::NeedsAttentionAuctionListItem.new(auction) }
  end
end
