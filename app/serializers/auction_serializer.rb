class AuctionSerializer < ActiveModel::Serializer
  attributes(
    :bids,
    :created_at,
    :customer,
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
    veiled_bids.map do |bid|
      BidSerializer.new(bid, scope: scope, root: false)
    end
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

  def customer
    find_customer.agency_name
  end

  def winning_bid
    WinningBidSerializer.new(find_winning_bid)
  end

  private

  def veiled_bids
    if object.type == 'sealed_bid' && auction_status.available?
      object.bids.where(bidder: scope)
    else
      object.bids
    end
  end

  def find_winning_bid
    if auction_status.available?
      NullBid.new
    else
      WinningBid.new(object).find
    end
  end

  def find_customer
    object.customer || NullCustomer.new
  end

  def auction_status
    @_auction_status ||= AuctionStatus.new(object)
  end
end
