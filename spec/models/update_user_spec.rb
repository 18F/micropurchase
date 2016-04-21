require 'rails_helper'

RSpec.describe UpdateUser do
  let(:updater) { UpdateUser.new(params, current_user) }
  let(:current_user) { FactoryGirl.create(:user, sam_account: true) }
  let(:valid_duns_number) { '012345678' }

  let(:params) do
    ActionController::Parameters.new(
      id: user_id,
      user: {
        duns_number: valid_duns_number
      }
    )
  end

  context 'when current user is not the same as the user being edited' do
    let(:user) { FactoryGirl.create(:user) }
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
    let(:params) do
      ActionController::Parameters.new(id: user_id)
    end

    it 'raises some param related error' do
      expect { updater.save }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context 'when user is found and can be edited by current user' do
    let(:user_id) { user.id }
    let(:user) { current_user }

    context 'user updates DUNS to invalid DUNS number' do
      it 'raises validation error' do
        old_duns_number = user.duns_number
        params = ActionController::Parameters.new(
          id: user_id,
          user: {
            duns_number: "BAD"
          }
        )

        updater = UpdateUser.new(params, current_user)
        updater.save

        expect(updater.errors).to eq(
          'DUNS number format is invalid'
        )
        expect(user.duns_number).to eq old_duns_number
      end
    end

    context 'user updates DUNS to nil' do
      it 'does not raise validation error' do
        params = ActionController::Parameters.new(
          id: user_id,
          user: {
            duns_number: nil
          }
        )

        updater = UpdateUser.new(params, current_user)
        updater.save

        expect(updater.errors).to eq('')
      end
    end

    it 'update the user when current user is the user' do
      updater.save
      user.reload
      expect(user.duns_number).to eq(valid_duns_number)
    end

    it 'clears the sam id, when it has changed' do
      updater.save
      user.reload
      expect(user.sam_account).to eq(false)
    end
  end
end
