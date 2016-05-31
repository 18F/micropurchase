class AuctionStatus::Expiring < AuctionStatus::Open
  def label_class
    'auction-label-expiring'
  end

  def label
    'Expiring'
  end
end
