require_relative '../feature_helper'

RSpec.describe 'User edit flow' do
  before do
    User.delete_all
  end

  describe '/users/:id/edit' do
    let(:user) { User.create }

    it 'raises a 404 when user is not found' do
      get '/users/101/edit', {}, session_authentication
      expect(last_response.status).to eq(404)
    end

    it 'raises a 400 when user is not in session' do
      get "/users/#{user.id}/edit", {}, session_authentication(user.id + 1000)
      expect(last_response.status).to eq(400)
    end

    it 'render the form when the user is found and same as in session' do
      get "/users/#{user.id}/edit", {}, session_authentication(user.id)
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include('SAM')
    end
  end
end
