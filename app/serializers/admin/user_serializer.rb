module Admin
  class UserSerializer < ActiveModel::Serializer
    #   has_many :bids, serializer: Admin::BidSerializer
    attributes :github_id,  :duns_number,
               :name,       :created_at,
               :updated_at, :email,
               :sam_account
  end
end
