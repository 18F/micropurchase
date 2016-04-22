require 'rails_helper'

RSpec.describe DataDotGovCredentials do
  let(:vcap_json) do
    JSON.parse(File.read('spec/support/vcap_services.json'))
  end
  let(:data_dot_gov_api_key) do
    data_dot_gov = vcap_json['user-provided']
      .find {|service| service['name'] == 'data-dot-gov'}

    data_dot_gov['credentials']['api_key']
  end

  describe '::api_key' do
    let(:api_key) { DataDotGovCredentials.api_key(force_vcap: true) }
    it 'returns a string' do
      expect(api_key).to eq(data_dot_gov_api_key)
    end
  end
end
