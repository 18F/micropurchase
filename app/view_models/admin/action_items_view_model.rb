class Admin::ActionItemsViewModel
  def delivery_past_due
    list_items(AuctionQuery.new.delivery_past_due)
  end

  def evaluation_needed
    list_items(AuctionQuery.new.evaluation_needed)
  end

  def complete_and_successful
    list_items(AuctionQuery.new.complete_and_successful)
  end

  def payment_pending
    list_items(AuctionQuery.new.payment_pending)
  end

  def payment_needed
    list_items(AuctionQuery.new.payment_needed)
  end

  private

  def list_items(auctions)
    auctions.map { |auction| Admin::ActionListItem.new(auction) }
  end
end
