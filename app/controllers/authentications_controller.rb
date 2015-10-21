class AuthenticationsController < ApplicationController
  def create
    redirect_to(Authenticator.new(request.env['omniauth.auth'], session).perform)
  end
end
