class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  # for actions that don't require_authentication or require_admin,
  # we still need to set_current_user_to_api_user so that users can
  # optionally have authenticated access to public routes.
  # for example, /auctions/:id/bids will unveil bidder info about
  # the authenticated user. but the page also works fine sans authentication.
  before_action :set_api_current_user

  delegate(
    :current_user,
    :github_id,
    :require_admin,
    :require_authentication,
    :set_api_current_user,
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
    if @authenticator.nil?
      @authenticator = if html_request? || csv_request?
                         WebAuthenticator.new(self)
                       elsif api_request?
                         ApiAuthenticator.new(self)
                       else
                         fail UnauthorizedError, "Unable to authenticate"
                       end
    end

    @authenticator
  end

  def html_request?
    request.format.html?
  end

  def csv_request?
    request.format == :csv
  end

  def api_request?
    request.format.json?
  end

  def handle_error(message)
    if html_request?
      flash[:error] = message
      redirect_to '/'
    elsif api_request?
      render json: { error: message }, status: 404
    end
  end

  def store_location
    if request.get?
      session[:return_to] = request.original_fullpath
    end
  end
end
