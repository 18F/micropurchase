require 'rails_helper'

RSpec.describe DataDotGovCredentials do
  describe '::api_key' do
    let(:api_key) { DataDotGovCredentials.api_key(force_vcap: true) }
    it 'returns a string' do
      data_dot_gov_api_key_from_fixture = 'fakeapikey'
      expect(api_key).to eq(data_dot_gov_api_key_from_fixture)
    end
  end
end
