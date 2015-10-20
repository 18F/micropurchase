class Authenticator < Struct.new(:auth_hash, :session)
  attr_reader :user

  def perform
    find_or_create_user
    sign_in
    redirect_url
  end

  private

  def find_or_create_user
    @user = found_user || created_user
  end

  def sign_in
    session[:user_id] = user.id
  end

  def redirect_url
    admin? ? '/' : "/users/#{user.id}/edit"
  end

  def github_id
    auth_hash[:uid]
  end

  def found_user
    User.where(github_id: github_id).first
  end

  def created_user
    User.create(github_id: github_id)
  end

  def admin?
    Admins.verify?(github_id)
  end
end
