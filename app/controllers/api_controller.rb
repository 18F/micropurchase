class ApiController < ApplicationController
  def authenticator
    @_authenticator ||= ApiAuthenticator.new(self)
  end

  def handle_error(message, code = 404)
    render json: { error: message }, status: code
  end
end
