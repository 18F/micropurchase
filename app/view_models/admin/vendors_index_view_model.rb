class Admin::VendorsIndexViewModel < Admin::BaseViewModel
  def users
    all_users.reject(&:admin?)
  end

  def vendors_nav_class
    'usa-current'
  end

  def csv_download_partial
    'admin/vendors/csv_download_button'
  end

  private

  def all_users
    User.all.map { |user| UserPresenter.new(user) }
  end
end
