class UsersController < ApplicationController
  before_action :require_authentication

  def edit
    @user = current_user
    @user.decorate.sam_status_message_for(flash)
  end

  def update
    updater = UpdateUser.new(params, current_user)
    if updater.save
      redirect_to root_path
    else
      @user = updater.user
      flash.now[:error] = updater.errors
      render :edit
    end
  end
end
