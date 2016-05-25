class BidsConfirmViewModel
  attr_reader :auction, :bid

  def initialize(auction:, bid:)
    @auction = auction
    @bid = bid
  end

  def auction_id
    auction.id
  end

  def bid_amount
    bid.amount
  end

  def title
    auction.title
  end

  def time_left_partial
    if available?
      'bids/relative_time_left'
    else
      'components/null'
    end
  end

  def html_description
    return '' if auction.description.blank?
    MarkdownRender.new(auction.description).to_s.html_safe
  end

  def relative_time_left
    HumanTime.new(time: auction.ended_at).relative_time_left
  end

  private

  def available?
    AuctionStatus.new(auction).available?
  end
end
