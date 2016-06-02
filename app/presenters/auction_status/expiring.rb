class AuctionStatus::Expiring < AuctionStatus::Available
  def label_class
    'auction-label-expiring'
  end

  def label
    'Expiring'
  end
end
