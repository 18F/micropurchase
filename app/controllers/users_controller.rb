class UsersController < ApplicationController
  def edit
    fail UnauthorizedError if current_user.nil?

    @user = current_user
    @user.decorate.sam_status_message_for(flash)
  end

  def update
    require_authentication

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
