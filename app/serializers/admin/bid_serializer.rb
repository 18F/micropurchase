module Admin
  class BidSerializer < ActiveModel::Serializer
    has_one :bidder, class_name: 'User', serializer: Admin::UserSerializer

    attributes :bidder_id,  :auction_id,
               :amount,     :created_at,
               :updated_at, :id
               #:bidder

    # def bidder
    #   serializer = Admin::UserSerializer.serializer_for(object.bidder).new(object.bidder)
    #   ActiveModel::Serializer::Adapter::Json.new(serializer).as_json
    # end
  end
end
