require 'rails_helper'

describe GithubCredentials do
  context "using env var" do
    it "returns correct value" do
      env_var_client_id = "super secret key"
      env_var_secret = "super secret secret"
      ENV['micropurchase_github_client_id'] = env_var_client_id
      ENV['micropurchase_github_secret'] = env_var_secret

      client_id = GithubCredentials.client_id
      secret = GithubCredentials.secret

      expect(client_id).to eq env_var_client_id
      expect(secret).to eq env_var_secret
    end
  end
end
