class UpdateUser < Struct.new(:params, :current_user)
  attr_reader :status

  def save
    fail UnauthorizedError unless allowed_to_edit?

    update_user
  end

  def errors
    user.errors.full_messages.to_sentence
  end

  def user
    @user ||= User.find(params[:id])
  end

  private

  def update_user
    user.assign_attributes(user_params)
    update_sam
    @status = user.save
  end

  def allowed_to_edit?
    current_user == user
  end

  def update_sam
    reckoner = SamAccountReckoner.new(user)

    reckoner.clear
    reckoner.set! unless user.duns_number.blank?
  rescue
    # do nothing
  end

  def user_params
    params.require(:user).permit(:name, :duns_number, :email, :credit_card_form_url)
  end
end
