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
    :skills,
    :start_price,
    :started_at,
    :summary,
    :title,
    :type,
    :updated_at,
    :winning_bid
  )

  def bids
    veiled_bids.map do |bid|
      BidSerializer.new(bid, scope: scope, root: false)
    end
  end

  def skills
    object.sorted_skill_names
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
    if object.type == 'sealed_bid' && bidding_status.available?
      object.bids.where(bidder: scope)
    else
      object.bids
    end
  end

  def find_winning_bid
    if bidding_status.available?
      NullBid.new
    else
      WinningBid.new(object).find
    end
  end

  def find_customer
    object.customer || NullCustomer.new
  end

  def bidding_status
    @_bidding_status ||= BiddingStatus.new(object)
  end
end
