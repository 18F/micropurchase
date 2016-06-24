require "rails_helper"

# This file can be removed when the routing directive that sends JSON
# requests to the public controllers is also removed
RSpec.describe "Redirection to API" do
  include RequestHelpers

  describe 'a get request' do
    it 'should return a redirect to the correct location' do
      login
      get "/auctions.json", nil, headers

      expect(response.status).to eq 301
      expect(response.headers["Location"]).to include("/api/v0/auctions")
    end
  end
end
