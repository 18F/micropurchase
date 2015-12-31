class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    fail UnauthorizedError if current_user != @user
  end

  def update
    require_authentication and return

    @user = User.find(params[:id])
    fail UnauthorizedError if current_user != @user
    @user.update(user_params)

    if @user.save
      redirect_to '/'
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:duns_number, :email)
  end
end
