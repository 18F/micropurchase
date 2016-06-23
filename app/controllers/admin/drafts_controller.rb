class Admin::DraftsController < Admin::BaseController
  def index
    @view_model = Admin::DraftAuctionsViewModel.new
  end
end
