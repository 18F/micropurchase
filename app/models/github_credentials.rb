class GithubCredentials
  def self.client_id(force_vcap: false)
    return ENV['MPT_3500_GITHUB_KEY'] if use_env_var?(force_vcap)
    credentials['client_id']
  end

  def self.secret(force_vcap: false)
    return ENV['MPT_3500_GITHUB_SECRET'] if use_env_var?(force_vcap)
    credentials['secret']
  end

  def self.use_env_var?(force_vcap)
    !force_vcap && (Rails.env.development? or Rails.env.test?)
  end

  def self.credentials
    user_provided_service('micropurchase-github')['credentials']
  end

  def self.vcap_services
    JSON.parse(ENV['VCAP_SERVICES'])
  end

  def self.user_provided_services
    vcap_services['user-provided']
  end

  def self.user_provided_service(name)
    user_provided_services.find {|service| service['name'] == name }
  end
end
