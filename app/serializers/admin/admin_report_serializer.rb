module Admin
  class AdminReportSerializer < ActiveModel::Serializer
    attributes :quick_stats,
               :non_admin_users,
               :admin_users
  end
end
