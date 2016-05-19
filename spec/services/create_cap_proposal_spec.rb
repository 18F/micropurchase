require 'rails_helper'

describe CreateCapProposal do
  describe '#perform' do
    context 'when the C2 API is working' do
      it 'sends the correct attributes to the c2_client' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        fake_cap_attributes = { fake_cap: 'fake' }
        attributes_double = double(perform: fake_cap_attributes)
        allow(ConstructCapAttributes).to receive(:new).with(auction).and_return(attributes_double)

        fake_cap_proposal_id = 123
        body_double = double(id: fake_cap_proposal_id)
        response_double = double(body: body_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post).with('proposals', fake_cap_attributes).and_return(response_double)

        cap_proposal = CreateCapProposal.new(auction).perform

        expect(c2_client_double).to have_received(:post).with('proposals', fake_cap_attributes)
        expect(cap_proposal).to include("proposals/#{fake_cap_proposal_id}")
        expect(cap_proposal).to be_url
      end

      it 'updates the auction with the cap_proposal' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        fake_cap_attributes = { fake_cap: 'fake' }
        attributes_double = double(perform: fake_cap_attributes)
        allow(ConstructCapAttributes).to receive(:new).with(auction).and_return(attributes_double)

        fake_cap_proposal_id = 123
        body_double = double(id: fake_cap_proposal_id)
        response_double = double(body: body_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post).with('proposals', fake_cap_attributes).and_return(response_double)

        expect do
          CreateCapProposal.new(auction).perform
          auction.reload
        end
          .to change { auction.cap_proposal_url }
            .from('')
            .to("https://c2-dev.18f.gov/proposals/#{fake_cap_proposal_id}")
      end
    end

    context 'when the C2 API is failing' do
      it 'raises a CreateCapProposal::Error' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        attributes_double = double(perform: {})
        allow(ConstructCapAttributes).to receive(:new).with(auction).and_return(attributes_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post).with('proposals', {}).and_raise(Faraday::ClientError.new(nil, nil))

        cap_proposal = CreateCapProposal.new(auction)
        expect { cap_proposal.perform }.to raise_error(CreateCapProposal::Error)
      end
    end
  end
end
