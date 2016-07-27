class Admin::UsersController < Admin::BaseController
  def show
    user = User.find(params[:id])
    @view_model = Admin::UserShowViewModel.new(user)
  end

  def edit
    user = User.find(params[:id])
    @view_model = Admin::EditUserViewModel.new(user)
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      flash[:success] = "User with email #{user.email} updated successfully"
      redirect_to admin_admins_path
    else
      flash.now[:error] = user.errors.full_messages.to_sentence
      @view_model = Admin::EditUserViewModel.new(user)
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:contracting_officer)
  end
end
