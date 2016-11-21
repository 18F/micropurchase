require 'concerns/user_provided_service'

class DataDotGovCredentials
  extend UserProvidedService

  def self.api_key
    if use_env_var?
      ENV['DATA_DOT_GOV_API_KEY']
    else
      credentials('data-dot-gov')['api_key']
    end
  end
end
