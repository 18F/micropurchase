require "rails_helper"

describe WebAuthenticator, type: :model do
  let(:session) { {user_id: user.id} }
  let(:controller) { double('controller', session: session) }
  let(:authenticator) { WebAuthenticator.new(controller) }

  describe 'require_authentication' do
    context 'when no current user' do
      let(:session) { {} }

      it 'raises a RedirectToLogin error' do
        expect do
          authenticator.require_authentication
        end.to raise_error(UnauthorizedError::RedirectToLogin)
      end
    end

    context 'when user_id is not found in the database' do
      let(:session) { {user_id: 99_999_999} }

      it 'raises a RedirectToLogin error' do
        expect do
          authenticator.require_authentication
        end.to raise_error(UnauthorizedError::RedirectToLogin)
      end
    end

    context 'when the user is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it 'should not raise an error' do
        expect { authenticator.require_authentication }.to_not raise_error
      end
    end
  end
  describe 'require_admin' do
    context 'when no current user' do
      let(:session) { {} }

      it 'redirects to authenticate' do
        expect do
          authenticator.require_admin
        end.to raise_error(UnauthorizedError::RedirectToLogin)
      end
    end

    context 'when current user is not an admin' do
      let(:user) { FactoryGirl.create(:user) }

      it 'raises an authorization error' do
        expect { authenticator.require_admin }.to raise_error(UnauthorizedError::MustBeAdmin)
      end
    end

    context 'when current user is an admin' do
      let(:user) { FactoryGirl.create(:admin_user) }

      it 'does not raise an error' do
        expect { authenticator.require_admin }.not_to raise_error
      end
    end
  end
end
