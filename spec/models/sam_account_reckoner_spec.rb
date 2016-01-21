require 'rails_helper'

RSpec.describe SamAccountReckoner do
  let(:reckoner) { SamAccountReckoner.new(user) }
  let(:client) { double('samwise client', duns_is_in_sam?: in_sam?) }
  let(:in_sam?) { false }

  before do
    allow(Samwise::Client).to receive(:new).and_return(client)
  end

  describe '#set' do
    context 'when user has a valid duns number' do
      let(:user) { User.new(duns_number: 'i-am-here-yo') }
      let(:in_sam?) { true }

      it 'use the client to find determine if there is a sams account' do
        expect(client).to receive(:duns_is_in_sam?).with(duns: user.duns_number).and_return(in_sam?)
        reckoner.set
        expect(user.sam_account).to eq(true)
      end
    end

    context 'when sam_account is already set to true' do
      let(:user) { User.new(sam_account: true) }

      it 'does not check for an account via the client' do
        expect(client).not_to receive(:duns_is_in_sam?)
        reckoner.set
      end
    end

    context 'when the duns number is not present in sam' do
      let(:user) { User.new(duns_number: 'scamming') }

      it 'use the client to find determine if there is a sams account' do
        expect(client).to receive(:duns_is_in_sam?).with(duns: user.duns_number).and_return(in_sam?)
        reckoner.set
        expect(user.sam_account).to eq(false)
      end
    end
  end

  describe '#clear' do
    let(:user) { User.create(sam_account: true, duns_number: 'foo') }

    context 'when the user is not persisted' do
      it 'does not change the sam account' do
        reckoner.clear
        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has not changed' do
      before do
        user.save
      end

      it 'does not change the sam account' do
        reckoner.clear
        expect(user.sam_account).to eq(true)
      end
    end

    context 'when the duns number has changed' do
      before do
        user.save
        user.duns_number = 'bar'
      end

      it 'clears the sam account validation' do
        reckoner.clear
        expect(user.sam_account).to eq(false)
      end
    end
  end
end
