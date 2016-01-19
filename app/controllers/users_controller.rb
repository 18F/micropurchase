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
    require_authentication and return

    @user = User.find(params[:id])
    fail UnauthorizedError if current_user != @user
    @user.update(user_params)

    if @user.save
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def redirect_back_or_default
    redirect_to(session[:return_to] || root_path)
    session[:return_to] = nil
  end

  def user_params
    params.require(:user).permit(:duns_number, :email)
  end
end
