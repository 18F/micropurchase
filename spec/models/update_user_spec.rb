require 'rails_helper'

RSpec.describe UpdateUser do
  let(:user) { FactoryGirl.create(:user) }
  let(:updater) { UpdateUser.new(params, user) }

  let(:user_id) { user.id }
  let(:user_duns) { user.duns_number }
  let(:user_credit_card_url) { 'https://random-example.com/pay' }

  let(:params) do
    ActionController::Parameters.new(
      id: user_id,
      user: {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        duns_number: user_duns,
        credit_card_form_url: user_credit_card_url
      })
  end

  context 'when current user is not the same as the user being edited' do
    let(:user2) { FactoryGirl.create(:user) }
    let(:user_id) { user2.id }

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
    let(:user_duns) { Faker::Company.duns_number }
    before { allow_any_instance_of(SamAccountReckoner).to receive(:set!) }

    it 'update the user when current user is the user' do
      updater.save
      user.reload
      expect(user.duns_number).to eq(user_duns)
    end

    it 'clears the sam id, when it has changed' do
      updater.save
      user.reload
      expect(user.sam_account).to eq(false)
    end
  end
end
