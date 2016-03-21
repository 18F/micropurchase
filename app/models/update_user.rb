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
    SamAccountReckoner.new(user).clear
    @status = user.save
  end

  def allowed_to_edit?
    current_user == user
  end

  def user_params
    params.require(:user).permit(:name, :duns_number, :email)
  end
end
