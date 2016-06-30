class Admin::EditCustomerViewModel < Admin::BaseViewModel
  attr_reader :customer

  def initialize(customer)
    @customer = customer
  end

  def record
    customer
  end
end
