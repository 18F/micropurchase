require 'rails_helper'

describe DataDotGovCredentials do
  context "using env var" do
    it "returns correct value" do
      env_var_api_key = "super secret api key"
      ENV['data_dot_gov_api_key'] = env_var_api_key

      api_key = DataDotGovCredentials.api_key

      expect(api_key).to eq env_var_api_key
    end
  end
end
