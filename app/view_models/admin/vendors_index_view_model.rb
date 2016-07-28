class Admin::VendorsIndexViewModel < Admin::BaseViewModel
  def users
    all_users.reject(&:admin?)
  end

  private

  def all_users
    User.all.map { |user| UserPresenter.new(user) }
  end
end
