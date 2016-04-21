require 'rails_helper'

RSpec.describe GithubCredentials do
  describe '::secret' do
    let(:secret) { GithubCredentials.secret(force_vcap: true) }
    it 'returns a string' do
      expect(secret).to be_a(String)
    end
  end

  describe '::client_id' do
    let(:client_id) { GithubCredentials.client_id(force_vcap: true) }
    it 'returns a string' do
      expect(client_id).to be_a(String)
    end
  end
end
