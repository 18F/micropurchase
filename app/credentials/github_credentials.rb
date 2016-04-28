class GithubCredentials

  def self.client_id
    ENV["micropurchase_github_client_id"]
  end

  def self.secret
    ENV["micropurchase_github_secret"]
  end
end
