class Admin::CustomersController < Admin::BaseController
  def index
    @view_model = Admin::CustomersIndexViewModel.new
  end

  def new
    @view_model = Admin::NewCustomerViewModel.new
  end

  def create
    customer = Customer.new(customer_params)

    if customer.save
      flash[:success] = I18n.t('controllers.admin.customers.create.success')
      redirect_to admin_customers_path
    else
      error_messages = customer.errors.full_messages.to_sentence
      flash[:error] = error_messages
      redirect_to :back
    end
  end

  def edit
    customer = Customer.find(params[:id])
    @view_model = Admin::EditCustomerViewModel.new(customer)
  end

  def update
    customer = Customer.find(params[:id])

    if customer.update(customer_params)
      flash[:success] = "Customer #{customer.agency_name} updated successfully"
      redirect_to admin_customers_path
    else
      flash.now[:error] = customer.errors.full_messages.to_sentence
      @view_model = Admin::EditCustomerViewModel.new(customer)
      render :edit
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:agency_name, :contact_name, :email)
  end
end
