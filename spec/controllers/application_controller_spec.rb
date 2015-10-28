require 'rails_helper'

RSpec.describe ApplicationController, controller: true do
  describe '#require_admin' do
    context 'when no current user' do
      it 'redirects to authenticate' do
        expect(controller).to receive(:redirect_to).with("/login")
        controller.require_admin
      end
    end

    context 'when current user is not an admin' do
      let(:current_user) { double('user', github_id: 'not-here') }

      before do
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      it 'raises an authorization error' do
        expect {
          controller.require_admin
        }.to raise_error(UnauthorizedError)
      end
    end

    context 'when current user is an admin' do
      let(:current_user) { double('user', github_id: Admins.github_ids.first) }

      before do
        allow(controller).to receive(:current_user).and_return(current_user)
      end

      it 'lets the request pass through' do
        expect(controller).to_not receive(:redirect_to)
        expect {
          controller.require_admin
        }.not_to raise_error
      end
    end
  end
end
