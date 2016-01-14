module Admin
  class UserSerializer < ActiveModel::Serializer
    attributes :github_id,
               :duns_number,
               :name,
               :email,
               :sam_account,
               :created_at,
               :updated_at

     def created_at
       object.created_at.iso8601
     end

     def updated_at
       object.created_at.iso8601
     end
  end
end
