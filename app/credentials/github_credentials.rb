require "concerns/user_provided_service"

class GithubCredentials
  extend UserProvidedService

  def self.client_id(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['MPT_3500_GITHUB_KEY']
    else
      credentials('micropurchase-github')['client_id']
    end
  end

  def self.secret(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['MPT_3500_GITHUB_SECRET']
    else
      credentials('micropurchase-github')['secret']
    end
  end
end
