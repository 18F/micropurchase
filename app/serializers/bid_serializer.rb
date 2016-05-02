class BidSerializer < ActiveModel::Serializer
  has_one :bidder, class_name: 'User', serializer: UserSerializer

  attributes(
    :amount,
    :auction_id,
    :bidder_id,
    :created_at,
    :id,
    :updated_at
  )

  def bidder_id
    object.veiled_bidder_attribute(:id, scope)
  end

  def bidder
    object.veiled_bidder(scope)
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.created_at.iso8601
  end
end
