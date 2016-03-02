class ApplicationController
  class WebAuthenticator < Struct.new(:controller)
    def current_user
      @current_user ||= User.where(id: controller.session[:user_id]).first
    end

    def require_authentication
      if current_user.nil?
        fail UnauthorizedError::RedirectToLogin
      end
    end

    def github_id
      current_user.github_id
    end
  end
end
