class GithubCredentials
  def self.client_id(force_vcap: false)
    return ENV['MPT_3500_GITHUB_KEY'] if !force_vcap && (Rails.env.development? or Rails.env.test?)
    return user_provided_service('micropurchase-github')['credentials']['client_id']
  end

  def self.secret(force_vcap: false)
    return ENV['MPT_3500_GITHUB_SECRET'] if !force_vcap && (Rails.env.development? or Rails.env.test?)
    return user_provided_service('micropurchase-github')['credentials']['secret']
  end

  def self.vcap_services
    JSON.parse(ENV['VCAP_SERVICES'])
  end

  def self.user_provided_services
    vcap_services['user-provided']
  end

  def self.user_provided_service(name)
    user_provided_services.find {|service| service['name'] == name}
  end
end
