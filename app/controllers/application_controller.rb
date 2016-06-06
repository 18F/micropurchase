class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :api_current_user

  delegate(
    :current_user,
    :github_id,
    :require_admin,
    :require_authentication,
    :api_current_user,
    :via,
    to: :authenticator
  )

  rescue_from 'UnauthorizedError::MustBeAdmin' do |error|
    message = error.message || "Unauthorized"
    handle_error(message)
  end

  rescue_from 'UnauthorizedError::RedirectToLogin' do |error|
    store_location
    redirect_to login_path
  end

  rescue_from 'UnauthorizedError::UserNotFound' do |error|
    message = error.message || "User not found"
    handle_error(message)
  end

  private

  def authenticator
    @_authenticator ||= set_authenticator
  end

  def set_authenticator
    if api_request?
      ApiAuthenticator.new(self)
    else
      WebAuthenticator.new(self)
    end
  end

  def api_request?
    request.format.json?
  end

  def handle_error(message)
    if api_request?
      render json: { error: message }, status: 404
    else
      flash[:error] = message
      redirect_to root_path
    end
  end

  def store_location
    if request.get?
      session[:return_to] = request.original_fullpath
    end
  end
end
