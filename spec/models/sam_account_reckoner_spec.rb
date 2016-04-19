require 'rails_helper'

describe SamAccountReckoner do
  describe '#set' do
    context 'when user has a valid duns number' do
      it 'use the client to find determine if there is a sams account' do
        client = double('samwise client', duns_is_in_sam?: true)
        allow(Samwise::Client).to receive(:new).and_return(client)
        user = FactoryGirl.create(:user)

        SamAccountReckoner.new(user).set

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when sam_account is already set to true' do
      it 'does not check for an account via the client' do
        client = double('samwise client', duns_is_in_sam?: false)
        user = FactoryGirl.create(:user, sam_account: true)
        allow(Samwise::Client).to receive(:new).and_return(client)

        reckoner = SamAccountReckoner.new(user)

        expect(client).not_to receive(:duns_is_in_sam?)
        reckoner.set
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
        client = double('samwise client', duns_is_in_sam?: false)
        allow(Samwise::Client).to receive(:new).and_return(client)

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has not changed' do
      it 'does not change the sam account' do
        user = FactoryGirl.create(:user, sam_account: true)
        client = double('samwise client', duns_is_in_sam?: false)
        allow(Samwise::Client).to receive(:new).and_return(client)

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has changed' do
      it 'clears the sam account validation' do
        user = FactoryGirl.create(:user, sam_account: true, duns_number: 'old')
        client = double('samwise client', duns_is_in_sam?: false)
        allow(Samwise::Client).to receive(:new).and_return(client)
        user.duns_number = 'new'

        SamAccountReckoner.new(user).clear

        expect(user.sam_account).to eq(false)
      end
    end
  end
end
