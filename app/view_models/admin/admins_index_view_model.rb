class Admin::AdminsIndexViewModel < Admin::BaseViewModel
  def admins
    all_users.select(&:admin?)
  end

  private

  def all_users
    User.all.map { |user| UserPresenter.new(user) }
  end
end
