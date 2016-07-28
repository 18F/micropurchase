class Admin::AdminsController < Admin::BaseController
  def index
    @view_model = Admin::AdminsIndexViewModel.new
  end
end
