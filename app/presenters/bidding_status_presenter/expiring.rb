class BiddingStatusPresenter::Expiring < BiddingStatusPresenter::Available
  def label_class
    'expiring'
  end

  def label
    'Expiring'
  end
end
