class Admin::UserSerializer < ActiveModel::Serializer
  attributes(
    :created_at,
    :duns_number,
    :email,
    :github_id,
    :github_login,
    :id,
    :name,
    :sam_status,
    :updated_at
  )

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end
end
