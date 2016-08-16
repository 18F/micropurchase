require 'rails_helper'

describe UsersController do
  describe '#update' do
    it 'redirects to authenticate when not logged in' do
      put :update, id: user.id, user: { duns_number: '222' }
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/sign_in')
    end

    it 'uses the UpdateUser class to update the user' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(false)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
    end

    it 'rerenders edit when the update fails' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(false)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
      expect(response).to render_template(:edit)
    end

    it 'redirects back home after successful edit' do
      expect_any_instance_of(UpdateUser).to receive(:save).and_return(true)
      put :update, { id: user.id, user: { duns_number: '222' } }, user_id: user.id
      expect(response).to be_redirect
      expect(response.location).to eq('http://test.host/')
    end
  end

  def user
    @_user ||=  create(:user)
  end
end
