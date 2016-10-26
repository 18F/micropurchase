class BiddingStatusPresenter::Over < BiddingStatusPresenter::Base
  def start_label
    I18n.t('bidding_status.over.start_label')
  end

  def deadline_label
    I18n.t('bidding_status.over.deadline_label')
  end

  def relative_time
    I18n.t('bidding_status.over.relative_time',
           time: auction.ended_at.strftime("%m/%d/%Y"))
  end

  def label_class
    'over'
  end

  def label
    I18n.t('bidding_status.over.label')
  end

  def bid_label(_user)
    if bids?
      I18n.t('bidding_status.over.bid_label',
             winner_name: winner_name,
             amount: winning_bid_amount_as_currency)
    else
      ''
    end
  end

  def tag_data_value_status
    label
  end

  def tag_data_label_2
    "Winning Bid"
  end

  def tag_data_value_2
    Currency.new(winning_bid.amount).to_s
  end

  private

  def bids?
    auction.bids.any?
  end

  def winning_bid
    @_bid ||= WinningBid.new(auction).find
  end

  def winner_name
    winning_bid.bidder_name
  end

  def winning_bid_amount_as_currency
    Currency.new(winning_bid.amount)
  end
end
