require 'rails_helper'

RSpec.describe Admin::AuctionsController do
  before do
    stub_github('/user') do
      github_response_for_user(admin)
    end
  end
  let!(:auctions) do
    10.times.to_a.map { FactoryGirl.create(:auction, :with_bidders) }
  end
  let(:admin)         { FactoryGirl.create(:admin_user, github_id: 86790) }
  let(:json_response) { JSON.parse(response.body) }
  let(:json_auctions) { json_response['auctions'] }
  let(:headers) do
    {
      'HTTP_ACCEPT' => 'text/x-json',
      'HTTP_API_KEY' => api_key
    }
  end

  context 'when the API key is invalid' do
    let(:api_key) { FakeGitHub::INVALID_API_KEY }

    before do
      get '/admin/auctions', nil, headers
    end

    it 'returns a 404 HTTP response' do
      expect(response.status).to eq 404
    end
  end

  context 'when the API key is missing' do
    let(:api_key) { nil }

    before do
      get '/admin/auctions', nil, headers
    end

    it 'returns a 404 HTTP response' do
      expect(response.status).to eq 404
    end
  end

  context 'when the API key is valid' do
    let(:api_key) { FakeGitHub::VALID_API_KEY }

    before do
      get '/admin/auctions', nil, headers
    end

    it 'returns a 200 HTTP response' do
      expect(response.status).to eq 200
    end

    it 'returns valid auctions' do
      expect(response).to match_response_schema('admin/auctions')
    end

    it 'returns iso8601 dates' do
      # until I can figure out how to validate iso8601 with json-schema:
      expect(json_auctions.first['created_at']).to eq(auctions.first.created_at.iso8601)
      expect(json_auctions.first['updated_at']).to eq(auctions.first.updated_at.iso8601)
      expect(json_auctions.first['start_datetime']).to eq(auctions.first.start_datetime.iso8601)
      expect(json_auctions.first['end_datetime']).to eq(auctions.first.end_datetime.iso8601)
    end
  end
end
