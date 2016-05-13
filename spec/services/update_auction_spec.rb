require 'rails_helper'

RSpec.describe UpdateAuction do
  let(:updater) { UpdateAuction.new(auction, params) }

  describe '#perform' do
    # happy path for updating most attributes
    context 'when changing the title' do
      let(:auction) { FactoryGirl.create(:auction, :delivery_deadline_expired) }
      let(:new_title) { 'The New Title' }
      let(:params) do
        {
          auction: {
            title: new_title
          }
        }
      end

      it 'updates the title' do
        expect { updater.perform }.to change { auction.title }.to(new_title)
      end
    end

    context 'when result is set to accepted' do
      before do
        allow(CreateCapProposalJob).to receive(:perform_later).with(auction.id).and_return(nil)
      end
      let(:fake_cap_url) { 'https://fake-cap.18f.gov/proposals/1234' }
      let(:auction) { FactoryGirl.create(:auction, :delivery_deadline_expired) }
      let(:params) do
        {
          auction: {
            result: 'accepted'
          }
        }
      end

      it 'calls the CreateCapProposalJob' do
        updater.perform
        expect(CreateCapProposalJob).to have_received(:perform_later).with(auction.id)
      end
    end

    context 'when result is set to rejected' do
      let(:auction) { FactoryGirl.create(:auction, :delivery_deadline_expired) }
      let(:params) do
        {
          auction: {
            result: 'rejected'
          }
        }
      end

      it 'does not set cap_proposal_url' do
        expect { updater.perform }.to_not change { auction.cap_proposal_url }
        expect(auction.cap_proposal_url).to_not be_a(String)
        expect(auction.cap_proposal_url).to be_nil
      end
    end
  end

  describe '#should_create_cap_proposal?' do
    context 'when there already is a cap_proposal_url' do
      let(:auction) { FactoryGirl.create(:auction, :payment_pending) }
      let(:params) do
        {
          auction: {
            title: 'A new auction title'
          }
        }
      end

      it 'should return false' do
        expect(updater.should_create_cap_proposal?).to be(false)
      end
    end

    context 'when there is not already a cap_proposal_url' do
      let(:auction) { FactoryGirl.create(:auction, :payment_needed) }

      context 'and params contains result=accepted' do
        let(:params) do
          {
            auction: {
              result: 'accepted'
            }
          }
        end

        it 'should return true' do
          expect(updater.should_create_cap_proposal?).to be(true)
        end
      end

      context 'and auction.result is set to rejected' do
        let(:params) do
          {
            auction: {
              result: 'rejected'
            }
          }
        end

        it 'should return false' do
          expect(updater.should_create_cap_proposal?).to be(false)
        end
      end
    end
  end
end
