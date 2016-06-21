class StatusPresenter::Future < Struct.new(:auction)
  def start_label
    "Bid start time"
  end

  def deadline_label
    "Bid deadline"
  end

  def relative_time
    "Starts #{HumanTime.new(time: auction.started_at).relative_time} from now"
  end

  def time_left_partial
    'components/null'
  end

  def bid_description_partial
    'bids/over_bid_description'
  end

  def bid_form_partial
    'bids/closed'
  end

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
