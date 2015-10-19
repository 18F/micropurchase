require_relative '../feature_helper'

RSpec.describe 'User edit flow' do
  before do
    User.delete_all
  end

  describe 'get /users/:id/edit' do
    let(:user) { User.create }

    it 'raises a 404 when user is not found' do
      get '/users/101/edit', {}, session_authentication
      expect(last_response.status).to eq(404)
    end

    it 'raises a 403 when user is not in session' do
      get "/users/#{user.id}/edit", {}, session_authentication(user.id + 1000)
      expect(last_response.status).to eq(403)
    end

    it 'render the form when the user is found and same as in session' do
      get "/users/#{user.id}/edit", {}, session_authentication(user.id)
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('SAM')
    end
  end

  describe 'put /users/:id' do
    let(:user) { User.create }

    it 'redirects to authentication when not logged in' do
      put '/users/101', {sam_id: '1111', duns_id: '2222'}
      expect(last_response).to be_redirect
      expect(last_response.location).to include('auth/github')
    end

    it 'raises a 403 when user is not in session' do
      put "/users/#{user.id}", {sam_id: '1111', duns_id: '2222'}, session_authentication(User.create.id)
      expect(last_response.status).to eq(403)
    end

    it 'redirects home' do
      put "/users/#{user.id}", {sam_id: '1111', duns_id: '2222'}, session_authentication(user.id)
      expect(last_response).to be_redirect
      expect(last_response.location).to eq("http://example.org/")
    end

    it 'updates the user' do
      put "/users/#{user.id}", {sam_id: '1111', duns_id: '2222'}, session_authentication(user.id)
      user.reload
      expect(user.sam_id).to eq('1111')
      expect(user.duns_id).to eq('2222')
    end
  end
end
