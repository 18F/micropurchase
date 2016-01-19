require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  describe '#edit' do
    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      expect { get :edit, {id: user.id + 1000}, user_id: user.id }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles it as unauthorized when user is not in session' do
      get :edit, {id: user.id}, user_id: FactoryGirl.create(:user).id
      expect(response).to redirect_to('/')
      expect(flash[:error]).to match(/unauthorized/i)
    end

    it 'render the form when the user is found and same as in session' do
      get :edit, {id: user.id}, user_id: user.id
      expect(response.status).to eq(200)
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    it 'redirects to authenticate when not logged in' do
      put :update, id: user.id, user: {duns_number: '222'}
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/login')
    end

    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      user_id = user.id + 1000
      expect { put :update, {id: user_id, user: {duns_number: '222'}}, user_id: user.id }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'handles as unauthorized when user is not in session' do
      put :update, {id: user.id, user: {duns_number: '222'}}, user_id: FactoryGirl.create(:user).id
      expect(response).to redirect_to('/')
      expect(flash[:error]).to match(/unauthorized/i)
    end

    it 'update the user when current user is the user' do
      new_name = Faker::Name.name
      put :update, {id: user.id, user: {name: new_name, duns_number: '222'}}, user_id: user.id
      user.reload
      expect(user.duns_number).to eq('222')
    end

    it 'redirects back home after successful edit' do
      put :update, {id: user.id, user: {duns_number: '222'}}, user_id: user.id
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/')
    end
  end
end
