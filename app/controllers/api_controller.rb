class ApiController < ApplicationController
  def authenticator
    @_authenticator ||= ApiAuthenticator.new(self)
  end

  def handle_error(message, code = :not_found)
    render json: { error: message }, status: code
  end

  rescue_from 'ActiveRecord::RecordNotFound' do |error|
    message = error.message || 'Record Not Found'
    handle_error(message, :not_found)
  end
end
