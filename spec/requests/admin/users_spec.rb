require 'rails_helper'

describe Admin::UsersController do
  include RequestHelpers

  before do
    stub_github('/user') do
      github_response_for_user(admin)
    end
  end
  let!(:non_admin_users) { FactoryGirl.create_list(:user, 2, sam_status: :sam_accepted) }
  let(:admin) { FactoryGirl.create(:admin_user, github_id: 86790) }
  let(:json_response) { JSON.parse(response.body) }
  let(:json_non_admin_users) { json_response['admin_report']['non_admin_users'] }
  let(:headers) do
    {
      'HTTP_ACCEPT' => 'text/x-json',
      'HTTP_API_KEY' => api_key
    }
  end

  describe 'GET /admin/users' do
    before do
      get admin_users_path, nil, headers
    end

    context 'when the API key is invalid' do
      let(:api_key) { FakeGitHub::INVALID_API_KEY }

      it 'returns a 404 HTTP response' do
        expect(response.status).to eq 404
      end
    end

    context 'when the API key is missing' do
      let(:api_key) { nil }

      it 'returns a 404 HTTP response' do
        expect(response.status).to eq 404
      end
    end

    context 'when the API key is valid' do
      let(:api_key) { FakeGitHub::VALID_API_KEY }

      it 'returns a 200 HTTP response' do
        expect(response.status).to eq 200
      end

      it 'returns a valid admin report of users' do
        expect(response).to match_response_schema('admin/users')
      end

      it 'returns iso8601 dates' do
        skip 'until the bug can be solved'
        expect(json_non_admin_users.map { |a| a['created_at'] }).to all(be_iso8601)
        expect(json_non_admin_users.map { |a| a['updated_at'] }).to all(be_iso8601)
      end
    end
  end
end
