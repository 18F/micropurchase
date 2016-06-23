class Admin::ActionItemsController < ApplicationController
  before_filter :require_admin

  def index
    @action_items = Admin::ActionItemsViewModel.new
  end
end
