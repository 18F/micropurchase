class WinnersController < ApplicationController
  def index
    @view_model = WinnersViewModel.new
  end
end
