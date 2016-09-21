class BiddingStatusPresenter::Expiring < BiddingStatusPresenter::Available
  def label_class
    'auction-label-expiring'
  end

  def label
    'Expiring'
  end
end
