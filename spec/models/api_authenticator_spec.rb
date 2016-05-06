require "rails_helper"

describe ApiAuthenticator, type: :model do
  let(:api_key)   { '12345' }
  let(:headers) { { 'HTTP_API_KEY' => api_key } }
  let(:request) { double('request', headers: headers) }
  let(:controller) { double('controller', request: request) }
  let(:authenticator) { ApiAuthenticator.new(controller) }

  describe "require_authentication" do
    context 'when the API key is absent' do
      let(:headers) { { } }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:user).and_raise(Octokit::Unauthorized)
      end

      it 'raises an authorization error' do
        expect do
          authenticator.require_authentication
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end

    context 'when the API key belongs to a non-registered person' do
      let(:github_id) { '1111' }
      before do
        allow(authenticator).to receive(:github_id)
          .and_return(github_id)
          .and_wrap_original { github_id }
      end

      it 'raises an authorization error' do
        expect do
          authenticator.require_authentication
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end

    context 'when the API key belongs to a user' do
      let(:user) { FactoryGirl.create(:user) }

      before do
        allow(authenticator).to receive(:github_id_from_api_key)
          .with(api_key)
          .and_return(user.github_id)
          .and_wrap_original { user.github_id }

        allow(Admins).to receive(:verify?)
          .with(user.github_id)
          .and_return(false)
          .and_wrap_original { false }
      end

      it 'should not raise an error' do
        expect do
          authenticator.require_authentication
        end.to_not raise_error
      end
    end
  end

  describe '#require_admin' do
    let(:github_id) { '67890' }

    context 'when the API key is absent' do
      let(:headers) { { } }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:user).and_raise(Octokit::Unauthorized)
      end

      it 'raises an authorization error' do
        expect do
          authenticator.require_admin
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end

    context 'when the API key belongs to a non-admin' do
      before do
        FactoryGirl.create(:user, github_id: github_id)

        allow(authenticator).to receive(:github_id_from_api_key)
          .with(api_key)
          .and_return(github_id)
          .and_wrap_original { github_id }

        allow(Admins).to receive(:verify?)
          .with(github_id)
          .and_return(false)
          .and_wrap_original { false }
      end

      it 'raises an authorization error' do
        expect do
          authenticator.require_admin
        end.to raise_error(UnauthorizedError::MustBeAdmin)
      end
    end

    context 'when the API key belongs to an admin' do
      let(:github_id) { '86790' }

      before do
        FactoryGirl.create(:user, github_id: github_id)

        allow(authenticator).to receive(:github_id)
          .and_return(github_id)
          .and_wrap_original { github_id }

        allow(Admins).to receive(:verify?)
          .with(github_id)
          .and_return(true)
      end

      it 'does not raise an error' do
        expect { authenticator.require_admin }.to_not raise_error
      end
    end
  end
end
