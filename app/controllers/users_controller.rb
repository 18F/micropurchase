class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    fail UnauthorizedError if current_user.nil? || current_user != @user

    if current_user.duns_number.blank?
      flash[:notice] = "You must supply a valid DUNS number"
    elsif !current_user.sam_account?
      flash[:notice] = "Unable to find your account on SAM, please confirm your DUNS number"
    end
  end

  def update
    require_authentication

    updater = UpdateUser.new(params, current_user)
    if updater.save
      redirect_to root_path
    else
      @user = updater.user
      flash[:error] = updater.errors
      render :edit
    end
  end
end
