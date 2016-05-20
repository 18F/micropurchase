require 'rails_helper'

describe Admin::AuctionsController do
  include RequestHelpers

  describe 'GET /admin/auctions' do
    context 'when the API key is invalid' do
      it 'returns a 404 HTTP response' do
        admin = FactoryGirl.create(:admin_user)
        stub_github('/user') { github_response_for_user(admin) }
        api_key = FakeGitHub::INVALID_API_KEY
        headers = {
          'HTTP_ACCEPT' => 'text/x-json',
          'HTTP_API_KEY' => api_key
        }

        get admin_auctions_path, nil, headers

        expect(response.status).to eq 404
      end
    end

    context 'when the API key is missing' do
      it 'returns a 404 HTTP response' do
        admin = FactoryGirl.create(:admin_user)
        stub_github('/user') { github_response_for_user(admin) }
        api_key = nil
        headers = {
          'HTTP_ACCEPT' => 'text/x-json',
          'HTTP_API_KEY' => api_key
        }

        get admin_auctions_path, nil, headers

        expect(response.status).to eq 404
      end
    end

    context 'when the API key is valid' do
      it 'returns a 200 HTTP response' do
        admin = FactoryGirl.create(:admin_user)
        stub_github('/user') { github_response_for_user(admin) }
        api_key = FakeGitHub::VALID_API_KEY
        headers = {
          'HTTP_ACCEPT' => 'text/x-json',
          'HTTP_API_KEY' => api_key
        }

        get admin_auctions_path, nil, headers

        expect(response.status).to eq 200
      end

      it 'returns valid auctions' do
        FactoryGirl.create(:auction, :with_bidders)
        admin = FactoryGirl.create(:admin_user)
        stub_github('/user') { github_response_for_user(admin) }
        api_key = FakeGitHub::VALID_API_KEY
        headers = {
          'HTTP_ACCEPT' => 'text/x-json',
          'HTTP_API_KEY' => api_key
        }

        get admin_auctions_path, nil, headers

        expect(response).to match_response_schema('admin/auctions')
      end

      it 'returns iso8601 dates' do
        FactoryGirl.create_list(:auction, 2, :with_bidders)
        admin = FactoryGirl.create(:admin_user)
        stub_github('/user') { github_response_for_user(admin) }
        api_key = FakeGitHub::VALID_API_KEY
        headers = {
          'HTTP_ACCEPT' => 'text/x-json',
          'HTTP_API_KEY' => api_key
        }

        get admin_auctions_path, nil, headers

        json_auctions = JSON.parse(response.body)['auctions']
        expect(json_auctions.map { |a| a['created_at'] }).to all(be_iso8601)
        expect(json_auctions.map { |a| a['updated_at'] }).to all(be_iso8601)
        expect(json_auctions.map { |a| a['started_at'] }).to all(be_iso8601)
        expect(json_auctions.map { |a| a['ended_at'] }).to all(be_iso8601)
      end
    end
  end
end
