require 'rails_helper'

RSpec.describe GithubCredentials do
  let(:vcap_json) do
    JSON.parse(File.read('spec/support/vcap_services.json'))
  end
  let(:github) do
    vcap_json['user-provided']
      .find {|service| service['name'] == 'micropurchase-github'}
  end
  let(:github_secret) { github['credentials']['secret'] }
  let(:github_client_id) { github['credentials']['client_id'] }

  describe '::secret' do
    let(:secret) { GithubCredentials.secret(force_vcap: true) }
    it 'returns a string' do
      expect(secret).to eq(github_secret)
    end
  end

  describe '::client_id' do
    let(:client_id) { GithubCredentials.client_id(force_vcap: true) }
    it 'returns a string' do
      expect(client_id).to eq(github_client_id)
    end
  end
end
