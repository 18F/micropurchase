class StatusPresenter::Available < StatusPresenter::Base
  def start_label
    "Bid start time"
  end

  def deadline_label
    "Bid deadline"
  end

  def relative_time
    "Ending in #{HumanTime.new(time: auction.ended_at).distance_of_time_to_now}"
  end

  def label_class
    'auction-label-open'
  end

  def label
    'Open'
  end

  def tag_data_value_status
    "#{HumanTime.new(time: auction.ended_at).distance_of_time_to_now} left"
  end

  def tag_data_label_2
    "Bidding"
  end

  def tag_data_value_2
    if auction.type == 'sealed_bid'
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
