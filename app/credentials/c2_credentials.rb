require 'concerns/user_provided_service'

class C2Credentials
  extend UserProvidedService

  def self.oauth_key
    if use_env_var?
      ENV['MICROPURCHASE_C2_OAUTH_KEY']
    else
      credentials('micropurchase-c2')['oauth_key']
    end
  end

  def self.oauth_secret
    if use_env_var?
      ENV['MICROPURCHASE_C2_OAUTH_SECRET']
    else
      credentials('micropurchase-c2')['oauth_secret']
    end
  end
end
