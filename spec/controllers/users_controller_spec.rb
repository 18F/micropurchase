require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { User.create }

  describe '#edit' do
    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      allow(controller).to receive(:current_user).and_return(user)
      expect {
        get :edit, {id: user.id + 1000}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles it as unauthorized when user is not in session' do
      allow(controller).to receive(:current_user).and_return(User.create)
      get :edit, {id: user.id}
      expect(response).to redirect_to('/')
      expect(flash[:error]).to match(/unauthorized/i)
    end

    it 'render the form when the user is found and same as in session' do
      allow(controller).to receive(:current_user).and_return(user)
      get :edit, {id: user.id}
      expect(response.status).to eq(200)
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    it 'redirects to authenticate when not logged in' do
      allow(controller).to receive(:current_user).and_return(nil)
      put :update, {id: user.id, user: {duns_number: '222'}}
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/login')
    end

    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      allow(controller).to receive(:current_user).and_return(user)
      user_id = user.id + 1000
      expect {
        put :update, {id: user_id, user: {duns_number: '222'}}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles as unauthorized when user is not in session' do
      allow(controller).to receive(:current_user).and_return(User.create)
      put :update, {id: user.id, user: {duns_number: '222'}}
      expect(response).to redirect_to('/')
      expect(flash[:error]).to match(/unauthorized/i)
    end

    it 'update the user when current user is the user' do
      allow(controller).to receive(:current_user).and_return(user)
      put :update, {id: user.id, user: {duns_number: '222'}}
      user.reload
      expect(user.duns_number).to eq('222')
    end

    it 'redirects back home after successful edit' do
      allow(controller).to receive(:current_user).and_return(user)
      put :update, {id: user.id, user: {duns_number: '222'}}
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/')
    end
  end
end
