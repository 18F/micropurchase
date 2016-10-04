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

  def successfully_delivered
    @_successfully_delivered ||= complete_and_successful_auctions.map do |auction|
      Admin::ClosedAuctionsListItemViewModel.new(auction)
    end
  end

  def rejected
    @_rejected ||= rejected_auctions.map do |auction|
      Admin::ClosedAuctionsListItemViewModel.new(auction)
    end
  end

  def archived
    @_archived ||= archived_auctions.map do |auction|
      Admin::ClosedAuctionsListItemViewModel.new(auction)
    end
  end

  def closed_auctions_nav_class
    'usa-current'
  end

  private

  def complete_and_successful_auctions
    AuctionQuery.new.complete_and_successful
  end

  def rejected_auctions
    AuctionQuery.new.rejected
  end

  def archived_auctions
    Auction.archived
  end
end
