class Admin::UsersController < ApplicationController
  before_filter :require_admin

  def index
    @view_model = Admin::UsersIndexViewModel.new
  end

  def show
    @user = UserPresenter.new(User.find(params[:id]))
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "User with email #{@user.email} updated successfully"
      redirect_to admin_users_path
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:contracting_officer)
  end
end
