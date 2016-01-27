module Admin
  class BidSerializer < ActiveModel::Serializer
    has_one :bidder, class_name: 'User', serializer: Admin::UserSerializer

    attributes :bidder_id,  :auction_id,
               :amount,     :created_at,
               :updated_at, :id
  end
end
