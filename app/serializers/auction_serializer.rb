class AuctionSerializer < ActiveModel::Serializer
  attributes :issue_url,
             :github_repo,
             :start_price,
             :start_datetime,
             :end_datetime,
             :title,
             :description,
             :id,
             :bids,
             :created_at,
             :updated_at,
             :summary

  def bids
    bids = object.veiled_bids(scope)
    bids.map { |bid| BidSerializer.new(bid, {scope: scope, root: false}) }
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
end
