class Admin::ActionItemsController < Admin::BaseController
  def index
    @view_model = Admin::ActionItemsViewModel.new
  end
end
