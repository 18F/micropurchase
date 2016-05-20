require 'rails_helper'

RSpec.describe CreateCapProposalJob, type: :job do

  describe '#perform' do
    let(:create_cap_proposal) { instance_double('CreateCapProposal', perform: fake_cap_url) }
    before do
      allow(CreateCapProposal).to receive(:new).and_return(create_cap_proposal)
    end
    let(:fake_cap_url) { 'https://fake-cap.18f.gov/proposals/1234' }
    let(:auction) { FactoryGirl.create(:auction, :delivery_due_at_expired, cap_proposal_url: nil) }
    let(:auction_presenter) { AuctionPresenter.new(auction) }

    it 'calls CreateCapProposal::new and #perform on the resulting instance' do
      CreateCapProposalJob.new.perform(auction.id)
      expect(create_cap_proposal).to have_received(:perform)
    end
  end
end
