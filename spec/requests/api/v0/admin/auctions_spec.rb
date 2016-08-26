require 'rails_helper'

describe Api::V0::Admin::AuctionsController do
  include RequestHelpers

  describe 'GET /admin/auctions' do
    it 'returns iso8601 dates' do
      FactoryGirl.create_list(:auction, 2, :with_bids)
      admin = FactoryGirl.create(:admin_user)
      stub_github('/user') { github_response_for_user(admin) }
      api_key = FakeGitHubApi::VALID_API_KEY
      headers = {
        'HTTP_ACCEPT' => 'text/x-json',
        'HTTP_API_KEY' => api_key
      }

      get api_v0_admin_auctions_path, nil, headers

      json_auctions = JSON.parse(response.body)['auctions']
      expect(json_auctions.map { |a| a['created_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['updated_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['started_at'] }).to all(be_iso8601)
      expect(json_auctions.map { |a| a['ended_at'] }).to all(be_iso8601)
    end
  end
end
