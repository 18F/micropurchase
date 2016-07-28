require 'rails_helper'

describe Api::V0::Admin::UsersController do
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
      get api_v0_admin_users_path, nil, headers
    end
    let(:api_key) { FakeGitHubApi::VALID_API_KEY }

    it 'returns iso8601 dates' do
      expect(json_non_admin_users.map { |a| a['created_at'] }).to all(be_iso8601)
      expect(json_non_admin_users.map { |a| a['updated_at'] }).to all(be_iso8601)
    end
  end
end
