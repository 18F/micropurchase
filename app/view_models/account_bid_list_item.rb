class MyBidListItem
  attr_reader :bid

  def initialize(bid)
    @bid = bid
  end

  def auction_title
    auction.title
  end

  def auction
    @_auction ||= bid.auction
  end

  def formatted_type
    auction.type.dasherize
  end

  def availability
    if available?
      'true'
    else
      'false'
    end
  end

  def amount
    Currency.new(bid.amount).to_s
  end

  def winning_status
    if available? && auction.type == 'sealed_bid'
      'n/a'
    elsif bid == winning_bid
      'true'
    else
      'false'
    end
  end

  def started_at
    formatted_time(auction.started_at)
  end

  def ended_at
    formatted_time(auction.ended_at)
  end

  def delivery_due_at
    formatted_time(auction.delivery_due_at)
  end

  private

  def available?
    BiddingStatus.new(auction).available?
  end

  def winning_bid
    auction.lowest_bid
  end

  def formatted_time(time)
    DcTimePresenter.convert(time).to_s(:long)
  end
end
