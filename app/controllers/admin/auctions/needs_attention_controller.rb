class Admin::Auctions::NeedsAttentionController < Admin::BaseController
  def index
    @view_model = Admin::NeedsAttentionAuctionsViewModel.new
  end
end
