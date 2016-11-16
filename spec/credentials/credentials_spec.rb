require 'rails_helper'

describe Credentials do
  around do |example|
    env_var_names = [
      'VCAP_SERVICES', 'C2_HOST', 'NEW_RELIC_APP_NAME',
      'DATA_DOT_GOV_API_KEY'
    ]
    env_vars = {}
    env_var_names.each do |name|
      env_vars[name] = ENV[name]
    end

    example.run

    env_var_names.each do |name|
      ENV[name] = env_vars[name]
    end
  end

  describe 'when local' do
    before do
      ENV['NEW_RELIC_APP_NAME'] = 'new-relic-app-name-here-too'
      ENV['DATA_DOT_GOV_API_KEY'] = 'data-gov-api-key'
    end

    it 'uses converts the names to get an envar directly' do
      expect(Credentials.get('new-relic', 'app_name')).to eq('new-relic-app-name-here-too')
    end

    it "returns finds the data dot gov api key" do
      expect(Credentials.get('data-dot-gov', 'api_key')).to eq('data-gov-api-key')
    end

    it "finds that same data dot gov api key via a mapped reference" do
      Credentials.map(:data_dot_gov_api_key, to: ['data-dot-gov', 'api_key'])
      expect(Credentials.data_dot_gov_api_key).to eq('data-gov-api-key')
    end
  end

  describe 'when on cloud foundry' do
    let(:vcap) {
      {
        'user-provided' => [
          'name' => 'new-relic',
          'app_name' => 'new-relic-app-name-here'
        ]
      }
    }

    before do
      allow(Rails).to receive(:env).and_return('production')
      ENV['VCAP_SERVICES'] = vcap.to_json
      ENV['C2_HOST'] = 'c2-host.something-app.gov'
    end

    it 'uses the variables found in vcap' do
      expect(Credentials.get('new-relic', 'app_name')).to eq('new-relic-app-name-here')
    end

    it 'bypasses cloud foundary config and goes to env vars when necessary' do
      expect(Credentials.get('c2_host')).to eq('c2-host.something-app.gov')
    end
  end
end
