class AuthenticationsController < ApplicationController
  def create
    path = Authenticator.new(request.env['omniauth.auth'], session).perform
    redirect_to(path)
  end

  def destroy
    reset_session
    redirect_to '/'
  end
end
