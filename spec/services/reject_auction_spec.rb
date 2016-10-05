require 'rails_helper'

describe RejectAuction do
  describe '#perform' do
    it 'should set the auction to be rejected' do
      auction = create(:auction, :pending_acceptance)

      RejectAuction.new(auction: auction).perform

      expect(auction.reload).to be_rejected
      expect(auction.rejected_at).to_not be_nil
    end

    context 'when the auction has an associated C2 proposal URL' do
      it 'should be set to c2_canceled' do
        auction = FactoryGirl.create(:auction, :pending_acceptance, :c2_budget_approved)
        allow(UpdateC2ProposalJob).to receive(:perform_later)
        RejectAuction.new(auction: auction).perform

        expect(auction.reload).to be_c2_canceled
      end

      it 'should enqueue a job to cancel the C2 proposal' do
        auction = FactoryGirl.create(:auction, :pending_acceptance, :c2_budget_approved)
        allow(UpdateC2ProposalJob).to receive(:perform_later)
        RejectAuction.new(auction: auction).perform

        expect(UpdateC2ProposalJob).to have_received(:perform_later).with(auction.id, 'C2CancelAttributes')
      end
    end
  end
end
