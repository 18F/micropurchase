class Admin::AuctionSerializer < ActiveModel::Serializer
  has_many :bids, serializer: Admin::BidSerializer

  attributes(
    :issue_url,
    :github_repo,
    :start_price,
    :started_at,
    :ended_at,
    :delivered_at,
    :delivery_url,
    :cap_proposal_url,
    :awardee_paid_status,
    :title,
    :description,
    :id,
    :created_at,
    :updated_at,
    :notes,
    :summary,
    :billable_to
  )

  def delivered_at
    object.delivered_at.try(:iso8601)
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
end
