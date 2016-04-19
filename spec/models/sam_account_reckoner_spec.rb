require 'rails_helper'

describe SamAccountReckoner do
  describe '#set' do
    context 'when user has a valid duns number' do
      it 'use the client to determine if there is a sams account' do
        user = FactoryGirl.create(:user, sam_account: false)
        client = double('samwise client')
        allow(Samwise::Client).to receive(:new).and_return(client)
        allow(client).to receive(:duns_is_in_sam?).with(duns: user.duns_number).and_return(true)

        SamAccountReckoner.new(user).set

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when sam_account is already set to true' do
      it 'does not check for an account via the client' do
        user = FactoryGirl.create(:user, sam_account: true)
        client = double('samwise client')
        allow(Samwise::Client).to receive(:new).and_return(client)
        allow(client).to receive(:duns_is_in_sam?).with(duns: user.duns_number).and_return(true)

        SamAccountReckoner.new(user).set

        expect(client).not_to have_received(:duns_is_in_sam?)
      end
    end

    context 'when the duns number is not present in sam' do
      it 'use the client to find determine if there is a sams account' do
        user = FactoryGirl.build(:user, sam_account: false, duns_number: 'scamming')
        client = double('samwise client', duns_is_in_sam?: false)
        allow(Samwise::Client).to receive(:new).and_return(client)

        SamAccountReckoner.new(user).set

        expect(user.sam_account).to eq(false)
      end
    end
  end

  describe '#clear' do
    context 'when the user is not persisted' do
      it 'does not change the sam account' do
        user = FactoryGirl.build(:user, sam_account: true)

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has not changed' do
      it 'does not change the sam account' do
        user = FactoryGirl.create(:user, sam_account: true)

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has changed' do
      it 'clears the sam account validation' do
        old_duns = "123456789"
        user = FactoryGirl.create(:user, sam_account: true, duns_number: old_duns)
        user.duns_number = '987654321'

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(false)
      end
    end
  end
end
