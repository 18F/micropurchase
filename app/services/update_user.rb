class UpdateUser < Struct.new(:params, :current_user)
  attr_reader :status

  def save
    fail UnauthorizedError unless allowed_to_edit?

    update_user
    user.save
  end

  def errors
    user.errors.full_messages.to_sentence
  end

  def user
    @user ||= User.find(params[:id])
  end

  private

  def update_user
    user.assign_attributes(parsed_user_params)
    update_sam
  end

  def allowed_to_edit?
    current_user == user
  end

  def update_sam
    reckoner = SamAccountReckoner.new(user)
    reckoner.set_default_sam_status
    reckoner.delay.set!
  end

  def parsed_user_params
    user_params.each_with_object({ }) do |(key, value), hash|
      converted_value = nil_not_empty_string(value)
      hash[key] = converted_value
    end
  end

  def user_params
    params
      .require(:user)
      .permit(:name, :duns_number, :email, :credit_card_form_url)
  end

  def nil_not_empty_string(value)
    if value == ""
      nil
    else
      value
    end
  end
end
