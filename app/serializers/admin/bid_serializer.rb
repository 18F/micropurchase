module Admin
  class BidSerializer < ActiveModel::Serializer
    has_one :bidder, class_name: 'User', serializer: Admin::UserSerializer

    attributes :bidder_id,
               :auction_id,
               :amount,
               :created_at,
               :updated_at,
               :id

    def created_at
      object.created_at.iso8601
    end

    def updated_at
      object.created_at.iso8601
    end
  end
end
