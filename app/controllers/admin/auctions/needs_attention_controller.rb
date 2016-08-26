class Admin::Auctions::NeedsAttentionController < Admin::BaseController
  def index
    @view_model = Admin::NeedsAttentionIndexViewModel.new
  end
end
