class Admin::NewCustomerViewModel < Admin::BaseViewModel
  def new_record
    Customer.new
  end
end
