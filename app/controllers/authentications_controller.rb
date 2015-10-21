class AuthenticationsController < ApplicationController
  def create
    redirect_to(Authenticator.new(env['omniauth.auth'], session).perform)
  end
end
