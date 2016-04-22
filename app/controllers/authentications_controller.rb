class AuthenticationsController < ApplicationController
  def create
    session[:return_to] ||= request.referer
    Authenticator.new(request.env['omniauth.auth'], session).perform
    redirect_to(path)
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  private

  def path
    if session[:return_to]
      session.delete(:return_to)
    else
      root_path
    end
  end
end
