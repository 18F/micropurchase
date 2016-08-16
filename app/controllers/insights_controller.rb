class InsightsController < ApplicationController
  def index
    @view_model = InsightsViewModel.new
  end
end
