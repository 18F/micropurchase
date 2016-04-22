require 'rails_helper'

RSpec.describe AuthenticationsController do
  describe '#create' do
    it 'should store the github uid in the session' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      get :create, provider: 'github'
      expect(session[:user_id]).to_not eq(nil)
    end

    it 'should redirect to root path if no return to set' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      request.env['HTTP_REFERER'] = nil

      get :create, provider: 'github'

      expect(response).to redirect_to("http://test.host/")
    end

    it 'should redirect to return to path if present' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      request.env['HTTP_REFERER'] = "http://test.host/auctions"

      get :create, provider: 'github'

      expect(response).to redirect_to("http://test.host/auctions")
    end

    it 'should create a new user' do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
      expect { get :create, provider: 'github' }.to change { User.count }.by(1)
      user = User.last
      expect(user.github_id).to eq(current_user_uid)
    end
  end

  describe '#destroy' do
    it 'resets the session' do
      session[:user_id] = 23
      get :destroy
      expect(session[:user_id]).to eq(nil)
    end
  end
end
