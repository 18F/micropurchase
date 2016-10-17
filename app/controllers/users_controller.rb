class UsersController < ApplicationController
  before_action :require_authentication

  def edit
    @view_model = EditUserViewModel.new(current_user)
  end

  def update
    updater = UpdateUser.new(params, current_user)
    if updater.save
      redirect_to root_path
    else
      @view_model = EditUserViewModel.new(current_user)
      flash.now[:error] = updater.errors
      render :edit
    end
  end

  def bids_placed
    @view_model = AccountBidsPlacedViewModel.new(current_user: current_user)
  end
end
