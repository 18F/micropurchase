require 'rails_helper'

describe GithubCredentials do
  context "using env var" do
    it "returns correct value" do
      env_var_client_id = "super secret key"
      env_var_secret = "super secret secret"
      ENV['MPT_3500_GITHUB_KEY'] = env_var_client_id
      ENV['MPT_3500_GITHUB_SECRET'] = env_var_secret

      client_id = GithubCredentials.client_id(force_vcap: false)
      secret = GithubCredentials.secret(force_vcap: false)

      expect(client_id).to eq env_var_client_id
      expect(secret).to eq env_var_secret
    end
  end

  context "parsing user provided service" do
    it "returns correct value" do
      fixture_key = "fakeclientid"
      fixture_secret = "fakesecret"

      client_id = GithubCredentials.client_id(force_vcap: true)
      secret = GithubCredentials.secret(force_vcap: true)

      expect(client_id).to eq fixture_key
      expect(secret).to eq fixture_secret
    end
  end
end
