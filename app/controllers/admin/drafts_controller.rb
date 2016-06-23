class Admin::DraftsController < ApplicationController
  before_filter :require_admin

  def index
    @auction_collection = Admin::DraftAuctionsViewModel.new
  end
end
