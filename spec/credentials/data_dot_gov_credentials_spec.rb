require 'rails_helper'

describe DataDotGovCredentials do
  around do |example|
    env_var = ENV['DATA_DOT_GOV_API_KEY']
    example.run
    ENV['DATA_DOT_GOV_API_KEY'] = env_var
  end


  context "using env var" do
    let(:env_var_api_key) { "super secret api key" }

    before do
      ENV['DATA_DOT_GOV_API_KEY'] = env_var_api_key
    end

    it "returns correct value" do
      expect(DataDotGovCredentials.api_key).to eq env_var_api_key
    end
  end
end
