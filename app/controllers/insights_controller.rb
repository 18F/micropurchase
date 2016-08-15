class InsightsController < ApplicationController
  caches_page :index

  def index
    @view_model = InsightsViewModel.new
  end
end
