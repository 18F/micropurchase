require 'rails_helper'

RSpec.describe ApplicationController, controller: true do
  describe '#require_authentication (via API)' do
    before do
      allow(controller).to receive(:api_request?).and_return(true)
      allow(controller).to receive(:html_request?).and_return(false)
    end

    context 'when the API key is absent' do
      before do
        allow(controller).to receive(:api_key).and_return(nil)
      end

      it 'raises an authorization error' do
        expect do
          controller.require_authentication
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end

    context 'when the API key belongs to a non-registered person' do
      let(:github_id) {'1111'}
      before do
        allow(controller).to receive(:github_id)
                              .and_return(github_id)
                              .and_wrap_original { github_id }
      end

      it 'raises an authorization error' do
        expect do
          controller.require_authentication
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end
  end

  describe '#require_admin (via API)' do
    before do
      allow(controller).to receive(:api_request?).and_return(true)
      allow(controller).to receive(:html_request?).and_return(false)
    end

    context 'when the API key is absent' do
      before do
        allow(controller).to receive(:api_key).and_return(nil)
      end

      it 'raises an authorization error' do
        expect do
          controller.require_admin
        end.to raise_error(UnauthorizedError::UserNotFound)
      end
    end

    context 'when the API key belongs to a non-admin' do
      let(:api_key)   { '12345' }
      let(:github_id) { '67890' }

      before do
        FactoryGirl.create(:user, github_id: github_id)

        allow(controller).to receive(:github_id_from_api_key)
                              .and_return(github_id)
                              .and_wrap_original { github_id }

        allow(controller).to receive(:api_key)
                              .and_return(api_key)
                              .and_wrap_original { api_key }

        allow(Admins).to receive(:verify?)
                          .with(github_id)
                          .and_return(false)
                          .and_wrap_original { false }
      end

      it 'raises an authorization error' do
        expect do
          controller.require_admin
        end.to raise_error(UnauthorizedError::MustBeAdmin)
      end
    end

    context 'when the API key belongs to an admin' do
      let(:github_id) { '86790' }
      before do
        FactoryGirl.create(:user, github_id: github_id)

        allow(controller).to receive(:github_id)
                              .and_return(github_id)
                              .and_wrap_original { github_id }

        allow(Admins).to receive(:verify?)
                          .with(github_id)
                          .and_return(true)
      end

      it 'does not raise an error' do
        expect { controller.require_admin }.to_not raise_error
      end
    end
  end

  describe '#require_admin (via browser)' do
    let(:current_user) { nil }
    before do
      allow(controller).to receive(:html_request?).and_return(true)
      allow(controller).to receive(:api_request?).and_return(false)
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    context 'when no current user' do
      it 'redirects to authenticate' do
        expect(controller).to receive(:redirect_to).with("/login")
        controller.require_admin
      end
    end

    context 'when current user is not an admin' do
      let(:current_user) { FactoryGirl.create(:user) }

      it 'raises an authorization error' do
        expect do
          controller.require_admin
        end.to raise_error(UnauthorizedError::MustBeAdmin)
      end
    end

    context 'when current user is an admin' do
      let(:current_user) { FactoryGirl.create(:admin_user) }

      it 'lets the request pass through' do
        expect(controller).to_not receive(:redirect_to)
        expect { controller.require_admin }.not_to raise_error
      end
    end
  end
end
