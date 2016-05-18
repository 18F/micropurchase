class LoginUser < Struct.new(:auth_hash, :session)
  def perform
    user.from_oauth_hash(auth_hash)
    sign_in
  end

  private

  def user
    @_user ||= FindOrRegisterUser.new(github_id: auth_hash[:uid]).perform
  end

  def sign_in
    session[:user_id] = user.id
  end
end
