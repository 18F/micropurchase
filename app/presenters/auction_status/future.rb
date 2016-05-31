class AuctionStatus::Future < Struct.new(:auction)
  def status_text
    'Closed'
  end

  def label_class
    'auction-label-future'
  end

  def label
    'Coming Soon'
  end

  def tag_data_value_status
    HumanTime.new(time: auction.started_at).relative_time
  end

  def tag_data_label_2
    "Starting bid"
  end

  def tag_data_value_2
    Currency.new(auction.start_price).to_s
  end
end
