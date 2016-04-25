class LoginUser < Struct.new(:auth_hash, :session)
  def perform
    user.from_oauth_hash(auth_hash)
    sign_in
    check_sam
  end

  private

  def user
    @_user ||= User.find_or_create_by(github_id: auth_hash[:uid])
  end

  def sign_in
    session[:user_id] = user.id
  end

  def check_sam
    return if user.sam_account?
    SamAccountReckoner.new(user).set!
  rescue
    # do nothing
  end
end
