require 'rails_helper'

describe Credentials do
  around do |example|
    env_var_names = ['VCAP_SERVICES', 'C2_HOST', 'NEW_RELIC_APP_NAME']
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
    end

    it 'uses converts the names to get an envar directly' do
      expect(Credentials.new.get('new-relic', 'app_name')).to eq('new-relic-app-name-here-too')
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
      expect(Credentials.new.get('new-relic', 'app_name')).to eq('new-relic-app-name-here')
    end

    it 'bypasses cloud foundary config and goes to env vars when necessary' do
      expect(Credentials.new.get('c2_host')).to eq('c2-host.something-app.gov')
    end
  end
end
