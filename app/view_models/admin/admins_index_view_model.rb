class Admin::AdminsIndexViewModel < Admin::BaseViewModel
  def admins
    all_users.select(&:admin?)
  end

  def admins_nav_class
    'usa-current'
  end

  def csv_download_partial
    'components/null'
  end

  private

  def all_users
    User.all.map { |user| UserPresenter.new(user) }
  end
end
