require_relative '../feature_helper'

RSpec.describe 'Logout' do
  describe '/logout' do
    it 'should store the github uid in the session' do
      get '/logout', {}, session_authentication
      expect(last_request.env['rack.session'][:uid]).to eq(nil)
    end

    it 'just hangs out there without rendering or redirecting ???'
  end
end
