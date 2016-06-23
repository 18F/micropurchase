class Admin::UsersIndexViewModel < Admin::BaseViewModel
  def admins
    all_users.select(&:admin?)
  end

  def users
    all_users.reject(&:admin?)
  end

  def user_count
    users.length
  end

  def admin_count
    admins.length
  end

  def non_admin_users_in_sam_count
    admin_report.non_admin_users_in_sam.length
  end

  def non_admin_users_with_duns_count
    admin_report.non_admin_users_with_duns.length
  end

  def users_nav_class
    'usa-current'
  end

  private

  def all_users
    User.all.map { |user| UserPresenter.new(user) }
  end

  def admin_report
    AdminReport.new(users: all_users)
  end
end
