class BiddingStatusPresenter::Future < BiddingStatusPresenter::Base
  def start_label
    I18n.t('bidding_status.future.start_label')
  end

  def deadline_label
    I18n.t('bidding_status.future.deadline_label')
  end

  def bid_label(_user)
    I18n.t('bidding_status.future.bid_label',
           amount: Currency.new(auction.start_price).to_s)
  end

  def relative_time
    I18n.t('bidding_status.future.relative_time',
           time: DcTimePresenter.new(auction.started_at).relative_time)
  end

  def label_class
    'future'
  end

  def label
    I18n.t('bidding_status.future.label')
  end

  def tag_data_value_status
    HumanTime.new(time: auction.started_at).relative_time
  end

  def tag_data_label_2
    I18n.t('bidding_status.future.tag_data_label_2')
  end

  def tag_data_value_2
    Currency.new(auction.start_price).to_s
  end
end
