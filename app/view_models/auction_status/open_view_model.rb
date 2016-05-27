class AuctionStatus::OpenViewModel < Struct.new(:auction)
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
