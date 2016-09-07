class Admin::MasqueradesController < Admin::BaseController
  skip_before_action :require_admin, only: [:destroy]

  def new
    session[:admin_id] = current_user.id
    user = User.find(params[:vendor_id])
    session[:user_id] = user.id
    flash[:success] = t('flashes.masquerades_controller.new', user_email: user.email)
    redirect_to root_path
  end

  def destroy
    user = User.find(session[:admin_id])
    session[:user_id] = user.id
    session[:admin_id] = nil
    flash[:success] = t('flashes.masquerades_controller.destroy')
    redirect_to root_path
  end
end
