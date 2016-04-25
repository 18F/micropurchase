class UsersController < ApplicationController
  def edit
    @user = User.find(params[:id])
    fail UnauthorizedError if current_user.nil? || current_user != @user

    if current_user.duns_number.blank?
      flash.now[:warning] = "You must supply a valid DUNS number"
    elsif current_user.sam_pending?
      flash.now[:warning] = "Your profile is pending while your DUNS number is
      being validated. This typically takes less than one hour"
    elsif current_user.sam_accepted?
      flash.now[:success] = "Your DUNS number has been verified in Sam.gov"
    elsif current_user.sam_rejected?
      flash.now[:error] = "Your DUNS number was not found in Sam.gov. Please enter
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
      flash.now[:error] = updater.errors
      render :edit
    end
  end
end
