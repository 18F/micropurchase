class Admin::CustomersIndexViewModel < Admin::BaseViewModel
  def customers
    Customer.order(:agency_name).all.map { |customer| CustomerPresenter.new(customer) }
  end

  def customer_count
    Customer.count
  end

  def customers_nav_class
    'usa-current'
  end
end
