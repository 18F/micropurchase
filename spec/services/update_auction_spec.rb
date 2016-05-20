require 'rails_helper'

describe UpdateAuction do
  describe '#perform' do
    context 'when changing the title' do
      it 'updates the title' do
        auction = create(:auction, :delivery_due_at_expired)
        new_title = 'The New Title'
        params = { auction: { title: new_title } }

        updater = UpdateAuction.new(auction, params)

        expect { updater.perform }.to change { auction.title }.to(new_title)
      end
    end

    context 'when result is set to accepted' do
      it 'calls the CreateCapProposalJob' do
        auction = create(:auction, :delivery_due_at_expired)
        allow(CreateCapProposalJob).to receive(:perform_later).with(auction.id).and_return(nil)
        params= { auction: { result: 'accepted' } }

        UpdateAuction.new(auction, params).perform

        expect(CreateCapProposalJob).to have_received(:perform_later).with(auction.id)
      end
    end

    context 'when result is set to rejected' do
      it 'does not set cap_proposal_url' do
        auction = create(:auction, :delivery_due_at_expired)
        params = { auction: { result: 'rejected' } }

        updater = UpdateAuction.new(auction, params)

        expect { updater.perform }.to_not change { auction.cap_proposal_url }
        expect(auction.cap_proposal_url).to eq ""
      end
    end
  end

  describe '#should_create_cap_proposal?' do
    context 'when there already is a cap_proposal_url' do
      it 'should return false' do
        auction = create(:auction, :payment_pending)
        params = { auction: { title: 'A new auction title' } }

        updater = UpdateAuction.new(auction, params)

        expect(updater.should_create_cap_proposal?).to be(false)
      end
    end

    context 'when there is not already a cap_proposal_url' do
      context 'and params contains result=accepted' do
        it 'should return true' do
          auction = create(:auction, :payment_needed)
          params = { auction: { result: 'accepted' } }

          updater = UpdateAuction.new(auction, params)

          expect(updater.should_create_cap_proposal?).to be(true)
        end
      end

      context 'and auction.result is set to rejected' do
        it 'should return false' do
          auction = create(:auction, :payment_needed)
          params = { auction: { result: 'rejected' } }

          updater = UpdateAuction.new(auction, params)

          expect(updater.should_create_cap_proposal?).to be(false)
        end
      end
    end
  end
end
