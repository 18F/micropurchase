class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    raise AuthorizationError if current_user != @user
  end

  def update
    require_authentication and return

    @user = User.find(params[:id])
    raise AuthorizationError if current_user != @user

    @user.update(user_params)

    redirect_to '/'
  end


  private

  def user_params
    params.require(:user).permit(:duns_id)
  end
end
