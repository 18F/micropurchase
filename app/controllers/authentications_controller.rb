class AuthenticationsController < ApplicationController
  def create
    redirect_to(Authenticator.new(request.env['omniauth.auth'], session).perform)
  end

  def destroy
    reset_session
    redirect_to '/'
  end
end
