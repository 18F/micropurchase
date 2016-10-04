require 'rails_helper'

describe ArchiveAuction do
  context 'for an unpublished auction' do
    it 'should set published to be archived' do
      auction = FactoryGirl.create(:auction, :unpublished)
      ArchiveAuction.new(auction: auction).perform

      expect(auction).to be_archived
      expect(auction.published).to eq("archived")
    end

    context 'when the auction has a c2_proposal_url' do
      it 'should set the c2_status to archived' do
        auction = FactoryGirl.create(:auction, :unpublished, :c2_budget_approved)
        allow(UpdateC2ProposalJob).to receive(:perform_later)
        ArchiveAuction.new(auction: auction).perform

        expect(auction.reload).to be_c2_cancelled
      end

      it 'should enqueue a job to cancel the C2 proposal' do
        auction = FactoryGirl.create(:auction, :unpublished, :c2_budget_approved)
        allow(UpdateC2ProposalJob).to receive(:perform_later)
        ArchiveAuction.new(auction: auction).perform

        expect(UpdateC2ProposalJob).to have_received(:perform_later).with(auction.id, 'C2CancelAttributes')
      end
    end
  end

  it 'should not be applied if the auction is published' do
    auction = FactoryGirl.create(:auction, :published)
    out = ArchiveAuction.new(auction: auction).perform

    expect(out).to be_falsey
    expect(auction).to_not be_archived
  end
end
