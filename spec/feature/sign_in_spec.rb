require_relative '../feature_helper'

RSpec.describe 'Sign in via github' do
  before do
    User.delete_all
  end

  describe '/auth/github/callback' do
    it 'should store the github uid in the session' do
      get '/auth/github/callback'
      expect(last_request.env['rack.session'][:uid]).to eq('12345')
    end

    it 'should redirect to edit the user' do
      get '/auth/github/callback'
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://example.org/users/#{User.last.id}/edit")
    end

    it 'should create a new user' do
      expect {
        get '/auth/github/callback'
      }.to change { User.count }.by(1)
      user = User.last
      expect(user.github_id).to eq('12345')
    end
  end
end
