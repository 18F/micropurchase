class SignInUser
  def initialize(auth_hash:, session:)
    @auth_hash = auth_hash
    @session = session
  end

  def perform
    update_user_from_oauth_hash!
    sign_in
  end

  private

  attr_reader :auth_hash, :session

  def update_user_from_oauth_hash!
    if_blank_set('name')
    if_blank_set('email')
    user.github_login = auth_hash[:info][:nickname]
    user.save!
  end

  def user
    @_user ||= User.find_or_initialize_by(github_id: auth_hash[:uid])
  end

  def sign_in
    session[:user_id] = user.id
  end

  def if_blank_set(field)
    attribute = field.to_sym

    if user.send(attribute).blank?
      value = auth_hash[:info][attribute] || ''
      user.send("#{attribute}=", value)
    end
  end
end
