class StatusPresenter::Over < Struct.new(:auction)
  def start_label
    "Auction started at"
  end

  def deadline_label
    "Auction ended at"
  end

  def relative_time
    auction.ended_at.strftime("Ended on: %m/%d/%Y")
  end

  def label_class
    'auction-label-over'
  end

  def label
    'Closed'
  end

  def tag_data_value_status
    label
  end

  def tag_data_label_2
    "Winning Bid"
  end

  def tag_data_value_2
    Currency.new(lowest_bid.amount).to_s
  end

  private

  def lowest_bid
    auction.lowest_bid || NullBid.new
  end
end
