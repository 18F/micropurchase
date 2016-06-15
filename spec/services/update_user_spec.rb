require 'rails_helper'

RSpec.describe UpdateUser do
  let(:updater) { UpdateUser.new(params, user) }
  let(:user) { FactoryGirl.create(:user, sam_status: :sam_accepted) }
  let(:user_id) { user.id }
  let(:user_duns_number) { user.duns_number }
  let(:user_credit_card_url) { 'https://random-example.com/pay' }

  let(:params) do
    ActionController::Parameters.new(
      id: user_id,
      user: {
        name: Faker::Name.name,
        duns_number: user_duns_number,
        email: "random#{rand(10000)}@example.com",
        credit_card_form_url: user_credit_card_url
      }
    )
  end

  context 'when SAM.gov says the vendor is a small business' do
    it 'sets small_business to true' do
      user = create(:user)
      params = ActionController::Parameters.new(
        id: user.id,
        user: {
          name: Faker::Name.name,
          duns_number: FakeSamApi::SMALL_BUSINESS_DUNS,
          email: "random#{rand(10000)}@example.com",
          credit_card_form_url: user.credit_card_form_url
        }
      )
      UpdateUser.new(params, user).save

      Delayed::Worker.new.work_off
      user.reload

      expect(user.small_business).to eq(true)
    end
  end

  context 'when SAM.gov (via Samwise) says the vendor is not a small business' do
    it 'does not set small_business to true' do

      user = create(:user)
      params = ActionController::Parameters.new(
        id: user.id,
        user: {
          name: Faker::Name.name,
          duns_number: FakeSamApi::BIG_BUSINESS_DUNS,
          email: "random#{rand(10000)}@example.com",
          credit_card_form_url: user.credit_card_form_url
        }
      )
      UpdateUser.new(params, user).save

      Delayed::Worker.new.work_off
      user.reload

      expect(user.small_business).to eq(false)
    end
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
      let(:user_duns_number) { 'BAD' }

      it 'raises validation error' do
        old_duns_number = user.duns_number
        updater.save
        expect(updater.errors).to eq('DUNS number format is invalid')
        expect(user.duns_number).to eq old_duns_number
      end
    end

    context 'user updates DUNS to nothing' do
      let(:user_duns_number) { '' }

      it 'does not raise validation error' do
        updater.save
        expect(updater.errors).to eq('')
      end
    end

    context 'user updates DUNS to a valid number' do
      let(:user_duns_number) { Faker::Company.duns_number }

      it 'clears the sam id, when it has changed' do
        updater.save
        user.reload
        expect(user).to be_sam_pending
      end

      it 'calls the SamAccountReckoner through a delayed job' do
        reckoner = double('reckoner', set_default_sam_status: true)
        allow(SamAccountReckoner).to receive(:new).with(user).and_return(reckoner)
        delayed_job = double(set!: true)
        allow(reckoner).to receive(:delay).and_return(delayed_job)

        updater.save

        expect(reckoner).to have_received(:delay)
        expect(delayed_job).to have_received(:set!)
      end
    end
  end
end
