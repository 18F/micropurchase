require 'rails_helper'

RSpec.describe UpdateUser do
  let(:updater) { UpdateUser.new(params, user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user_id) { user.id }
  let(:valid_duns_number) { '012345678' }
  let(:user_credit_card_url) { 'https://random-example.com/pay' }

  let(:params) do
    ActionController::Parameters.new(
      id: user_id,
      user: {
        name: Faker::Name.name,
        duns_number: valid_duns_number,
        email: Faker::Internet.email,
        credit_card_form_url: user_credit_card_url
      }
    )
  end

  context 'when current user is not the same as the user being edited' do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:user_id) { other_user.id }

    it 'raises UnauthorizedError' do
      expect { updater.save }.to raise_error(UnauthorizedError)
    end
  end

  context 'when the user being edited does not exist' do
    let(:user_id) { user.id + 1000 }

    it 'raises a ActiveRecord::RecordNotFound when user is not found' do
      expect { updater.save }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when the params are insufficient' do
    let(:user_id) { user.id }
    let(:params) do
      ActionController::Parameters.new(id: user_id)
    end

    it 'raises some param related error' do
      expect { updater.save }.to raise_error(ActionController::ParameterMissing)
    end
  end

  context 'when the credit_card_url is not valid' do
    let(:user_credit_card_url) { 'fiff13t913jt10h' }

    it 'raises an error on the save' do
      expect(updater.save).to be_falsey
      expect(updater.errors).to eq('Credit card form url is not a valid URL')
    end
  end

  context 'when the credit_card_url raises an exception' do
    context 'when the credit_card_url is not valid' do
      let(:user_credit_card_url) { 'hfdsgih9ghg' }
      before { allow_any_instance_of(URI::Parser).to receive(:parse).and_raise(URI::InvalidURIError) }

      it 'raises an error on the save' do
        expect(updater.save).to be_falsey
        expect(updater.errors).to eq('Credit card form url is not a valid URL')
      end
    end
  end

  context 'when user is found and can be edited by current user' do
    context 'user updates DUNS to invalid DUNS number' do
      it 'raises validation error' do
        user = FactoryGirl.create(:user)
        old_duns_number = user.duns_number
        params = ActionController::Parameters.new(
          id: user.id,
          user: {
            duns_number: "BAD"
          }
        )

        updater = UpdateUser.new(params, user)
        updater.save

        expect(updater.errors).to eq('DUNS number format is invalid')
        expect(user.duns_number).to eq old_duns_number
      end
    end

    context 'user updates DUNS to nil' do
      it 'does not raise validation error' do
        user = FactoryGirl.create(:user)
        params = ActionController::Parameters.new(
          id: user.id,
          user: {
            duns_number: nil
          }
        )

        updater = UpdateUser.new(params, user)
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

    it 'calls the SamAccountReckoner through a delayed job' do
      reckoner = double('reckoner', clear: true)
      allow(SamAccountReckoner).to receive(:new).with(user).and_return(reckoner)
      delayed_job = double(set!: true)
      allow(reckoner).to receive(:delay).and_return(delayed_job)
      
      updater.save

      expect(reckoner).to have_received(:delay)
      expect(delayed_job).to have_received(:set!)
    end
  end
end
