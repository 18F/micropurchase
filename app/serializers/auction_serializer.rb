class AuctionSerializer < ActiveModel::Serializer
  attributes(
    :bids,
    :created_at,
    :description,
    :end_datetime,
    :github_repo,
    :id,
    :issue_url,
    :start_datetime,
    :start_price,
    :summary,
    :title,
    :updated_at
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

  def end_datetime
    object.end_datetime.iso8601
  end

  def start_datetime
    object.start_datetime.iso8601
  end

  def winning_bid
    WinningBidSerializer.new(find_winning_bid)
  end

  private

  def find_winning_bid
    RulesFactory.new(object).create.winning_bid
  end
end
