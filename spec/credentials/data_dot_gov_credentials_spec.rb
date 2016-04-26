require 'rails_helper'

describe DataDotGovCredentials do
  context "using env var" do
    it "returns correct value" do
      env_var_api_key = "super secret api key"
      ENV['DATA_DOT_GOV_API_KEY'] = env_var_api_key

      api_key = DataDotGovCredentials.api_key(force_vcap: false)

      expect(api_key).to eq env_var_api_key
    end
  end

  context "parsing user provided service" do
    it "returns correct value" do
      fixture_api_key = "fakeapikey"

      api_key = DataDotGovCredentials.api_key(force_vcap: true)

      expect(api_key).to eq fixture_api_key
    end
  end
end
