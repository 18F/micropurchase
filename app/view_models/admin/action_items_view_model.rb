class Admin::ActionItemsViewModel < Admin::BaseViewModel
  def action_items_nav_class
    'usa-current'
  end

  def delivery_past_due
    list_items(AuctionQuery.new.delivery_past_due)
  end

  def evaluation_needed
    list_items(AuctionQuery.new.evaluation_needed)
  end

  def complete_and_successful
    list_items(AuctionQuery.new.complete_and_successful)
  end

  def payment_needed
    list_items(AuctionQuery.new.payment_needed)
  end

  def rejected
    list_items(AuctionQuery.new.rejected)
  end

  private

  def list_items(auctions)
    auctions.map { |auction| Admin::ActionItemListItem.new(auction) }
  end
end
