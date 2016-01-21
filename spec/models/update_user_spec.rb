require 'rails_helper'

RSpec.describe UpdateUser do
  let(:updater) { UpdateUser.new(params, current_user) }
  let(:current_user) { User.create(duns_number: '12341', sam_account: true) }

  let(:params) {
    ActionController::Parameters.new({
      id: user_id,
      user: {
        duns_number: 'new-new'
      }
    })
  }

  context 'when current user is not the same as the user being edited' do
    let(:user) { User.create }
    let(:user_id) { user.id }

    it 'raises UnauthorizedError' do
      expect { updater.save }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the user being edited does not exist' do
    let(:user_id) { current_user.id + 1000 }

    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      expect { updater.save }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the params are insufficient' do
    let(:user_id) { current_user.id }
    let(:params) {
      ActionController::Parameters.new({
        id: user_id
      })
    }

    it 'raises some param related error' do
      expect { updater.save }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context 'when user is found and can be edited by current user' do
    let(:user_id) { user.id }
    let(:user) { current_user }

    it 'update the user when current user is the user' do
      updater.save
      user.reload
      expect(user.duns_number).to eq('new-new')
    end

    it 'clears the sam id, when it has changed' do
      updater.save
      user.reload
      expect(user.sam_account).to eq(false)
    end
  end
end
