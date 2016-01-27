module Admin
  class AuctionSerializer < ActiveModel::Serializer
    has_many :bids, serializer: Admin::BidSerializer

    attributes :issue_url,      :start_price,
               :start_datetime, :end_datetime,
               :title,          :description,
               :created_at,     :updated_at,
               :summary,        :id
  end
end
