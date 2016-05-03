class AuctionStatus:: ExpiringViewModel < AuctionStatus::OpenViewModel
  def label_class
    'auction-label-expiring'
  end

  def label
    'Expiring'
  end
end
