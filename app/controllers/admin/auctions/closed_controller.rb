class Admin::Auctions::ClosedController < Admin::BaseController
  def index
    @view_model = Admin::ClosedAuctionsViewModel.new
  end
end
