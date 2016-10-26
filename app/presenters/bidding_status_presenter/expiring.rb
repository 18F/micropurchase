class BiddingStatusPresenter::Expiring < BiddingStatusPresenter::Available
  def label_class
    'expiring'
  end

  def label
    I18n.t('bidding_status.expiring.label')
  end
end
