class ApiAuthenticator < Struct.new(:controller)
  attr_reader :current_user

  def require_authentication
    set_api_current_user(raise_errors: true)
  end

  def require_admin
    require_authentication
    Admins.verify_or_fail!(github_id)
  end

  def api_key
    controller.request.headers['HTTP_API_KEY']
  end

  def github_id
    return github_id_from_api_key(api_key)
  rescue UnauthorizedError::GitHubAuthenticationError
    return nil
  end

  # rubocop:disable Style/AccessorMethodName
  def set_api_current_user(raise_errors: false)
    user = User.where(github_id: github_id).first

    fail UnauthorizedError::UserNotFound if user.nil? && raise_errors
    @current_user = user
  end
  # rubocop:enable Style/AccessorMethodName

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
