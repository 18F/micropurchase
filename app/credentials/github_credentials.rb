require 'concerns/user_provided_service'

class GithubCredentials
  extend UserProvidedService

  def self.client_id
    if use_env_var?
      ENV['MICROPURCHASE_GITHUB_CLIENT_ID']
    else
      credentials('micropurchase-github')['client_id']
    end
  end

  def self.secret
    if use_env_var?
      ENV['MICROPURCHASE_GITHUB_SECRET']
    else
      credentials('micropurchase-github')['secret']
    end
  end
end
