class ApplicationController
  class WebAuthenticator < Struct.new(:controller)
    def current_user
      @current_user ||= User.where(id: controller.session[:user_id]).first
    end

    def set_api_current_user
    end

    def require_authentication
      fail UnauthorizedError::RedirectToLogin if current_user.nil?
    end

    def require_admin
      require_authentication
      Admins.verify_or_fail!(github_id)
    end

    def github_id
      current_user.github_id
    end
  end
end
