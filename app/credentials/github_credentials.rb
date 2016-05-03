class GithubCredentials
  def self.client_id
    ENV["MICROPURCHASE_GITHUB_CLIENT_ID"]
  end

  def self.secret
    ENV["MICROPURCHASE_GITHUB_SECRET"]
  end
end
