require "rails_helper"

# This file can be removed when the routing directive that sends JSON
# requests to the public controllers is alos removed
RSpec.describe "Redirection to API" do
  include RequestHelpers

  describe 'a get request' do
    it 'should return a redirect to the correct location' do
      login
      auction = create(:auction, :with_bidders)
      get "/auctions/#{auction.id}.json", nil, headers

      expect(response.status).to eq 301
      expect(response.headers["Location"]).to include("/api/v0/auctions/#{auction.id}")
    end
  end
end
