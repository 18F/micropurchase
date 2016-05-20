class AuctionSerializer < ActiveModel::Serializer
  attributes(
    :bids,
    :created_at,
    :description,
    :ended_at,
    :github_repo,
    :id,
    :issue_url,
    :started_at,
    :start_price,
    :summary,
    :title,
    :updated_at,
    :winning_bid
  )

  def bids
    bids = object.veiled_bids(scope)
    bids.map { |bid| BidSerializer.new(bid, { scope: scope, root: false }) }
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end

  def ended_at
    object.ended_at.iso8601
  end

  def started_at
    object.started_at.iso8601
  end

  def winning_bid
    WinningBidSerializer.new(find_winning_bid)
  end

  private

  def find_winning_bid
    if auction_status.available?
      NullBid.new
    else
      WinningBid.new(object).find
    end
  end

  def auction_status
    @_auction_status ||= AuctionStatus.new(object)
  end
end
