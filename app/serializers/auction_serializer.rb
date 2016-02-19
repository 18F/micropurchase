class AuctionSerializer < ActiveModel::Serializer
  has_many :bids, serializer: BidSerializer

  attributes :issue_url,
             :github_repo,
             :start_price,
             :start_datetime,
             :end_datetime,
             :title,
             :description,
             :id,
             :created_at,
             :updated_at,
             :summary

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.created_at.iso8601
  end

  def end_datetime
    object.end_datetime.iso8601
  end

  def start_datetime
    object.start_datetime.iso8601
  end
end
