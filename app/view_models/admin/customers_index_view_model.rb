class Admin::CustomersIndexViewModel < Admin::BaseViewModel
  def customers
    Customer.order(:agency_name).all.map { |customer| CustomerPresenter.new(customer) }
  end

  def new_button_partial
    'admin/customers/new_customer_button'
  end

  def customers_nav_class
    'usa-current'
  end
end
