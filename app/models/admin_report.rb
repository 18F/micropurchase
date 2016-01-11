class AdminReport
  def initialize(users: [])
    @users = users
  end

  def non_admin_users
    @users.select {|u| !Admins.verify?(u.github_id)}
  end

  def non_admin_users_with_duns
    non_admin_users.select {|u| u.duns_number?}
  end

  def non_admin_users_in_sam
    non_admin_users.select {|u| u.sam_account == true}
  end
end
