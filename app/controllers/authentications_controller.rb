class AuthenticationsController < ApplicationController
  def create
    LoginUser.new(request.env['omniauth.auth'], session).perform
    redirect_back_or_root_path
  end

  def destroy
    reset_session
    redirect_to root_path
  end

  private

  def redirect_back_or_root_path
    redirect_to(return_to || root_path)
    clear_return_to
  end

  def return_to
    if return_to_url
      uri = URI.parse(return_to_url)
      "#{uri.path}?#{uri.query}".chomp('?')
    end
  end

  def return_to_url
    session[:return_to]
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
