class BidSerializer < ActiveModel::Serializer
  has_one :bidder, class_name: 'User', serializer: UserSerializer

  attributes :bidder_id,
             :auction_id,
             :amount,
             :created_at,
             :updated_at,
             :id

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
