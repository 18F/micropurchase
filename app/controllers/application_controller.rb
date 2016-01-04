class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.where(id: session[:user_id]).first
  end

  def require_authentication
    if html_request?
      redirect_if_not_logged_in!
    elsif api_request?
      set_current_user_to_api_user!
    end
  end

  def require_admin
    require_authentication and return
    fail UnauthorizedError, 'must be an admin' unless is_admin?
  end

  rescue_from UnauthorizedError do |error|
    message = error.message || "Unauthorized"

    if html_request?
      flash[:error] = message
      redirect_to '/'
    elsif api_request?
      render json: {error: message}, status: 404
    end
  end

  def html_request?
    request.format.symbol == :html
  end

  def api_request?
    [:json].include? request.format.symbol
  end

  def api_key
    request.headers['HTTP_API_KEY']
  end

  def github_id_from_api_key(api_key)
    begin
      client = Octokit::Client.new(access_token: api_key)
      client.user.id
    rescue Octokit::Unauthorized => e
      fail UnauthorizedError, "Error authenticating via GitHub: #{e.message}"
    end
  end

  def redirect_if_not_logged_in!
    should_redirect = !current_user
    redirect_to '/login' if should_redirect
    should_redirect
  end

  def set_current_user_to_api_user!
    user = User.where(github_id: github_id).first
    if user.nil?
      fail UnauthorizedError, 'User not found'
    else
      @current_user = user
    end
  end

  def github_id
    if html_request?
      current_user.github_id
    elsif api_request?
      github_id_from_api_key(api_key)
    end
  end

  def is_admin?
    Admins.verify?(github_id)
  end
end
