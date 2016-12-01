class UsersController < ApplicationController
  before_action :require_authentication

  def edit
    @view_model = EditUserViewModel.new(current_user)
    @view_model.sam_status_message_for(flash)
  end

  def update
    updater = UpdateUser.new(params, current_user)
    if updater.save
      redirect_to action: :edit
    else
      @view_model = EditUserViewModel.new(current_user)
      flash.now[:error] = updater.errors
      render :edit
    end
  end
end
