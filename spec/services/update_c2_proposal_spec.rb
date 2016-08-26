require 'rails_helper'

describe UpdateC2Proposal do
  describe '#perform' do
    it 'sends the correct attributes to the c2_client' do
      c2_path = "proposals/123"
      c2_proposal_url = "https://c2-dev.18f.gov/#{c2_path}"
      auction = create(:auction, :with_bidders, c2_proposal_url: c2_proposal_url)

      fake_c2_attributes = { fake_c2: 'fake' }
      attributes_double = double(to_h: fake_c2_attributes)

      attributes_class = double
      allow(attributes_class).to receive(:new).with(auction).and_return(attributes_double)

      c2_client_double = double
      allow(C2::Client).to receive(:new).and_return(c2_client_double)
      allow(c2_client_double).to receive(:put)
        .with(c2_path, fake_c2_attributes)

      UpdateC2Proposal.new(auction, attributes_class).perform

      expect(c2_client_double).to have_received(:put).with(c2_path, fake_c2_attributes)
    end
  end
end
