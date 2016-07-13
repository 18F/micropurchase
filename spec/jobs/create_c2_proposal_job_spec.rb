require 'rails_helper'

describe CreateC2ProposalJob do
  describe '#perform' do
    it 'calls CreateC2Proposal::new and #perform on the resulting instance' do
      fake_c2_url = 'https://fake-c2.18f.gov/proposals/1234'
      create_c2_proposal= instance_double('CreateC2Proposal', perform: fake_c2_url)
      auction = create(:auction, :delivery_due_at_expired, c2_proposal_url: nil)
      allow(CreateC2Proposal).to receive(:new).and_return(create_c2_proposal)

      CreateC2ProposalJob.new.perform(auction.id)

      expect(create_c2_proposal).to have_received(:perform)
    end
  end
end
