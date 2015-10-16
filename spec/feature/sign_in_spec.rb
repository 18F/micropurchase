require_relative '../feature_helper'

RSpec.describe 'Sign in via github' do
  describe '/auth/github/callback' do
    it 'should store the github uid in the session' do
      get '/auth/github/callback'
      expect(last_request.env['rack.session'][:uid]).to eq('123545')
    end

    it 'should redirect to home' do
      get '/auth/github/callback'
      expect(last_response).to be_redirect
      expect(last_response.location).to eq('http://example.org/')
    end
  end
end
