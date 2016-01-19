class AdminReport
  include ActiveModel::SerializerSupport

  def initialize(users: [])
    @users = users
  end

  def non_admin_users
    @users.select {|u| !Admins.verify?(u.github_id) }
  end

  def admin_users
    @users.select {|u| Admins.verify?(u.github_id) }
  end

  def quick_stats
    {
      total_users: non_admin_users.length,
      users_with_duns: non_admin_users_with_duns.length,
      users_in_sam: non_admin_users_in_sam.length,
      notes: 'None of these include admin users'
    }
  end

  def non_admin_users_with_duns
    non_admin_users.select(&:duns_number?)
  end

  def non_admin_users_in_sam
    non_admin_users.select(&:sam_account?)
  end
end
