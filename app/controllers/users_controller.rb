class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    fail UnauthorizedError if current_user.nil? || current_user != @user

    if current_user.duns_number.blank?
      flash[:notice] = "You must supply a valid DUNS number"
    elsif !current_user.sam_account?
      flash[:notice] = "Your DUNS number was not found in Sam.gov. Please enter
      a valid DUNS number to complete your profile. Check
      https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html to make
      sure your DUNS number is correct. If you need any help email us at
      micropurchase@gsa.gov"
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
