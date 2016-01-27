module Admin
  class UserSerializer < ActiveModel::Serializer
    attributes :github_id,  :duns_number,
               :name,       :created_at,
               :updated_at, :email,
               :sam_account
  end
end
