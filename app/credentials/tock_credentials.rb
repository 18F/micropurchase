require 'concerns/user_provided_service'

class TockCredentials
  extend UserProvidedService

  def self.api_token
    if use_env_var?
      ENV['MICROPURCHASE_TOCK_API_KEY']
    else
      credentials('micropurchase-tock')['api_key']
    end
  end
end
