require 'concerns/user_provided_service'

class NewRelicCredentials
  extend UserProvidedService

  def self.license_key
    if use_env_var?
      ENV['NEW_RELIC_API_KEY']
    else
      credentials('new-relic')['license_key']
    end
  end
end
