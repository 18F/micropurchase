require 'rails_helper'

describe UpdateUser do
  context 'when SAM.gov says the vendor is a small business' do
    it 'sets small_business to true' do
      user = create(:user)
      params = ActionController::Parameters.new(
        id: user.id, user: { duns_number: FakeSamApi::SMALL_BUSINESS_DUNS }
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
        id: user.id, user: { duns_number: FakeSamApi::BIG_BUSINESS_DUNS }
      )

      UpdateUser.new(params, user).save

      Delayed::Worker.new.work_off
      user.reload

      expect(user.small_business).to eq(false)
    end
  end

  context 'when the params are insufficient' do
    it 'raises some param related error' do
      params = ActionController::Parameters.new(id: user_id)

      expect { UpdateUser.new(params, user).save }
        .to raise_error(ActionController::ParameterMissing)
    end
  end

  context 'when the payment_url is not valid' do
    it 'raises an error on the save' do
      params = ActionController::Parameters.new(
        id: user_id, user: { payment_url: 'fiff13t913jt10h' }
      )

      updater = UpdateUser.new(params, user)

      expect(updater.save).to be_falsey
      expect(updater.errors).to eq('Payment url is not a valid URL')
    end
  end

  context 'when the payment_url raises an exception' do
    context 'when the payment_url is not valid' do
      it 'raises an error on the save' do
        allow_any_instance_of(URI::Parser).to receive(:parse).and_raise(URI::InvalidURIError)
        params = ActionController::Parameters.new(
          id: user_id, user: { payment_url: 'hfdsgih9ghg' }
        )

        updater = UpdateUser.new(params, user)

        expect(updater.save).to be_falsey
        expect(updater.errors).to eq('Payment url is not a valid URL')
      end
    end
  end

  context 'payment_url is updated for winning vendor' do
    context 'payment_url set to valid value' do
      it 'calls AcceptAuction' do
        auction = create(:auction, :with_bids, status: :accepted_pending_payment_url)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(payment_url: '')
        accepter = double(perform: true)
        new_payment_url = "http://example.com/payme"
        allow(AcceptAuction).to receive(:new)
          .with(auction: auction, payment_url: new_payment_url)
          .and_return(accepter)
        params = ActionController::Parameters.new(
          id: winning_bidder.id, user: { payment_url: new_payment_url }
        )

        UpdateUser.new(params, winning_bidder).save

        expect(accepter).to have_received(:perform)
      end
    end

    context 'payment_url set to invalid value' do
      it 'does not calls AcceptAuction' do
        auction = create(:auction, :with_bids, status: :accepted_pending_payment_url)
        winning_bidder = WinningBid.new(auction).find.bidder
        winning_bidder.update(payment_url: '')
        accepter = double(perform: true)
        allow(AcceptAuction).to receive(:new)
          .with(auction: auction, payment_url: '')
          .and_return(accepter)
        params = ActionController::Parameters.new(
          id: winning_bidder.id, user: { payment_url: 'blah' }
        )

        UpdateUser.new(params, winning_bidder).save

        expect(accepter).not_to have_received(:perform)
      end
    end
  end

  context 'when user is found and can be edited by current user' do
    context 'user updates DUNS to invalid DUNS number' do
      it 'raises validation error' do
        bad_duns_number = 'BAD'
        old_duns_number = user.duns_number
        params = ActionController::Parameters.new(
          id: user_id, user: { duns_number: bad_duns_number }
        )

        updater = UpdateUser.new(params, user)
        updater.save

        expect(updater.errors).to eq('DUNS number format is invalid')
        expect(user.reload.duns_number).to eq old_duns_number
      end
    end

    context 'user updates DUNS to nothing' do
      it 'does not raise validation error' do
        params = ActionController::Parameters.new(
          id: user_id, user: { duns_number: '' }
        )

        updater = UpdateUser.new(params, user)
        updater.save

        expect(updater.errors).to eq('')
      end
    end

    context 'user updates DUNS to a valid number' do
      it 'clears the sam id, when it has changed' do
        params = ActionController::Parameters.new(
          id: user_id, user: { duns_number: Faker::Company.duns_number }
        )

        updater = UpdateUser.new(params, user)
        updater.save

        user.reload
        expect(user).to be_sam_pending
      end

      it 'calls the SamAccountReckoner through a delayed job' do
        params = ActionController::Parameters.new(
          id: user_id, user: { duns_number: Faker::Company.duns_number }
        )
        reckoner = double('reckoner', set_default_sam_status: true)
        allow(SamAccountReckoner).to receive(:new).with(user).and_return(reckoner)
        delayed_job = double(set!: true)
        allow(reckoner).to receive(:delay).and_return(delayed_job)

        updater = UpdateUser.new(params, user)
        updater.save

        expect(reckoner).to have_received(:delay)
        expect(delayed_job).to have_received(:set!)
      end
    end

    context 'small business vendor changes DUNS to empty' do
      it 'set small_business to false and sam_status to :duns_blank' do
        user = create(:user, sam_status: :sam_accepted, small_business: true)
        params = ActionController::Parameters.new(
          id: user.id, user: { duns_number: '' }
        )

        UpdateUser.new(params, user).save

        Delayed::Worker.new.work_off
        user.reload
        expect(user.small_business).to eq(false)
        expect(user.sam_status).to eq('duns_blank')
      end
    end
  end

  def user
    @_user ||= create(:user, sam_status: :sam_accepted)
  end

  def user_id
    user.id
  end
end
