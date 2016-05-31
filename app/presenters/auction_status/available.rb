class AuctionStatus::Available < Struct.new(:auction)
  def start_label
    "Bid start time:"
  end

  def deadline_label
    "Bid deadline:"
  end

  def relative_time
    "Time remaining: #{HumanTime.new(time: auction.ended_at).distance_of_time}"
  end

  def time_left_partial
    'bids/time_left'
  end

  def bid_description_partial
    'bids/available_bid_description'
  end

  def bid_form_partial
    'bids/form'
  end

  def status_text
    'Open'
  end

  def label_class
    'auction-label-open'
  end

  def label
    'Open'
  end

  def tag_data_value_status
    "#{HumanTime.new(time: auction.ended_at).distance_of_time} left"
  end

  def tag_data_label_2
    "Bidding"
  end

  def tag_data_value_2
    if auction.type == 'single_bid'
      "Sealed"
    else
      "#{winning_bid_amount_as_currency} - #{auction.bids.length} bids"
    end
  end

  private

  def winning_bid_amount_as_currency
    Currency.new(lowest_bid.amount).to_s
  end

  def lowest_bid
    auction.lowest_bid || NullBid.new
  end
end
