class ApiAuthenticator < Struct.new(:controller)
  attr_reader :current_user

  def require_authentication
    api_current_user(raise_errors: true)
  end

  def require_admin
    require_authentication
    Admins.verify_or_fail!(github_id)
  end

  def api_key
    controller.request.headers['HTTP_API_KEY']
  end

  def github_id
    github_id_from_api_key(api_key)
  rescue UnauthorizedError::GitHubAuthenticationError
    nil
  end

  def api_current_user(raise_errors: false)
    user = User.where(github_id: github_id).first

    if user.nil? && raise_errors
      fail UnauthorizedError::UserNotFound
    end

    @current_user = user
  end

  def via
    'api'
  end

  private

  def github_id_from_api_key(api_key)
    return nil if api_key.nil?

    client = Octokit::Client.new(access_token: api_key)
    client.user.id
  rescue Octokit::Unauthorized => e
    raise UnauthorizedError::GitHubAuthenticationError, "Error authenticating via GitHub: #{e.message}"
  end
end
