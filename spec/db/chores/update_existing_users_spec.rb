require_relative "../../../db/chores/update_existing_users"

require 'rails_helper'

describe UpdateExistingUsers do
  describe '#perform' do
    context 'user has a github login' do
      it 'does not update user' do
        create(:user, github_login: 'abc')

        expect {
          UpdateExistingUsers.new.perform
        }.not_to raise_error
      end
    end

    context 'user has deleted github account' do
      it 'does not update user' do
        user = build(:user, github_login: nil, github_id: FakeGitHubApi::DELETED_USER_ID)
        user.save(validate: false)

        expect {
          UpdateExistingUsers.new.perform
        }.not_to raise_error
      end
    end

    context 'user has no name on github' do
      it 'updates login and email' do
        user = build(:user, github_login: nil, github_id: FakeGitHubApi::NO_NAME_USER_ID)
        user.save(validate: false)

        expect {
          UpdateExistingUsers.new.perform
        }.not_to raise_error
      end
    end

    context 'user has all data on github' do
      it 'updates login, email, and name' do
        user = build(:user, github_login: nil, github_id: '123')
        user.save(validate: false)
        github_login_from_fixture = 'pjhyett'

        expect {
          UpdateExistingUsers.new.perform
        }.not_to raise_error

        expect(user.reload.github_login).to eq github_login_from_fixture
      end
    end
  end
end
