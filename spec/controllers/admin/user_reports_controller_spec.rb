require 'rails_helper'

RSpec.describe Admin::UserReportsController do
  describe '#index' do
    context 'when called by an admin user' do
      it 'should return a CSV' do
        user = create(:admin_user)
        10.times { create(:user) }

        get :index, { format: 'csv' }, user_id: user.id

        expect(response.code).to eq('200')
        expect(response.header['Content-Type']).to include('text/csv')
      end
    end

    context 'when called by a non-admin user' do
      it 'should return a 302 redirection with an error' do
        user = create(:user)
        10.times { create(:user) }

        get :index, { format: 'csv' }, user_id: user.id

        expect(response.code).to eq('302')
      end
    end
  end
end
