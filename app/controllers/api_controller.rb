class ApiController < ApplicationController
  def authenticator
    @_authenticator ||= ApiAuthenticator.new(self)
  end

  def handle_error(message)
    render json: { error: message }, status: 404
  end
end
