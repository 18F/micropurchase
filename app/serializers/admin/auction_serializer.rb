class Admin::AuctionSerializer < ActiveModel::Serializer
  has_many :bids, serializer: Admin::BidSerializer

  attributes(
    :billable_to,
    :cap_proposal_url,
    :created_at,
    :delivery_due_at,
    :delivery_url,
    :description,
    :customer,
    :ended_at,
    :github_repo,
    :id,
    :issue_url,
    :notes,
    :paid_at,
    :start_price,
    :started_at,
    :summary,
    :title,
    :updated_at
  )

  def created_at
    object.created_at.iso8601
  end

  def delivery_due_at
    object.delivery_due_at.try(:iso8601)
  end

  def ended_at
    object.ended_at.iso8601
  end

  def started_at
    object.started_at.iso8601
  end

  def paid_at
    object.paid_at.try(:iso8601)
  end

  def updated_at
    object.updated_at.iso8601
  end

  def customer
    object.customer_name
  end
end
