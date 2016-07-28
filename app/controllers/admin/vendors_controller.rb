class Admin::VendorsController < Admin::BaseController
  def index
    @view_model = Admin::VendorsIndexViewModel.new
  end
end
