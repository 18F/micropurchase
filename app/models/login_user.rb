class LoginUser < Struct.new(:auth_hash, :session)
  def perform
    update_user_from_oauth_hash!
    sign_in
  end

  private

  def user
    @_user ||= User.find_or_create_by(github_id: auth_hash[:uid])
  end

  def update_user_from_oauth_hash!
    if_blank_set('name')
    if_blank_set('email')
    user.github_login = auth_hash[:info][:nickname]
    user.save!
  end

  def sign_in
    session[:user_id] = user.id
  end

  def if_blank_set(field)
    attribute = field.to_sym

    if user.send(attribute).blank?
      user.send("#{attribute}=", auth_hash[:info][attribute])
    end
  end
end
