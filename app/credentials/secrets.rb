require 'concerns/user_provided_service'

class Secrets
  extend UserProvidedService

  def self.secret_key_base
    if use_env_var?
      ''
    else
      credentials('secrets')['secret_key_base']
    end
  end
end
