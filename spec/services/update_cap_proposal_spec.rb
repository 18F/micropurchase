require 'rails_helper'

describe UpdateCapProposal do
  describe '#perform' do
    it 'sends the correct attributes to the c2_client' do
      c2_path = "proposals/123"
      cap_proposal_url = "https://c2-dev.18f.gov/#{c2_path}"
      auction = create(:auction, :with_bidders, :delivered, cap_proposal_url: cap_proposal_url)

      fake_cap_attributes = { fake_cap: 'fake' }
      attributes_double = double(perform: fake_cap_attributes)
      allow(UpdateCapAttributes).to receive(:new).with(auction).and_return(attributes_double)

      c2_client_double = double
      allow(C2::Client).to receive(:new).and_return(c2_client_double)
      allow(c2_client_double).to receive(:put).
        with(c2_path, fake_cap_attributes)

      UpdateCapProposal.new(auction).perform

      expect(c2_client_double).to have_received(:put).with(c2_path, fake_cap_attributes)
    end
  end
end
