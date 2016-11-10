class Admin::ClosedAuctionsViewModel < Admin::BaseViewModel
  def successful_partial
    if successfully_delivered.any?
      'admin/auctions/closed/successful'
    else
      'admin/auctions/closed/no_successful'
    end
  end

  def rejected_partial
    if rejected.any?
      'admin/auctions/closed/rejected'
    else
      'admin/auctions/closed/no_rejected'
    end
  end

  def archived_partial
    if archived.any?
      'admin/auctions/closed/archived'
    else
      'admin/auctions/closed/no_archived'
    end
  end

  def delivery_missed_partial
    if delivery_missed.any?
      'admin/auctions/closed/delivery_missed'
    else
      'admin/auctions/closed/no_delivery_missed'
    end
  end

  def delivery_missed
    @_delivery_missed ||= list_items(missed_delivery_auctions)
  end

  def successfully_delivered
    @_successfully_delivered ||= list_items(complete_and_successful_auctions)
  end

  def rejected
    @_rejected ||= list_items(rejected_auctions)
  end

  def archived
    @_archived ||= list_items(archived_auctions)
  end

  def closed_auctions_nav_class
    'usa-current'
  end

  private

  def list_items(auctions)
    auctions.map do |auction|
      Admin::ClosedAuctionsListItemViewModel.new(auction)
    end
  end

  def complete_and_successful_auctions
    AuctionQuery.new.complete_and_successful
  end

  def rejected_auctions
    AuctionQuery.new.rejected
  end

  def archived_auctions
    Auction.archived
  end

  def missed_delivery_auctions
    Auction.missed_delivery
  end
end
