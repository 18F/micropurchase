require 'rails_helper'

describe CreateC2Proposal do
  describe '#perform' do
    context 'when the C2 API is working' do
      it 'sends the correct attributes to the c2_client' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        fake_c2_attributes = { fake_c2: 'fake' }
        attributes_double = double(perform: fake_c2_attributes)
        allow(ConstructC2Attributes).to receive(:new)
          .with(auction)
          .and_return(attributes_double)

        fake_c2_proposal_id = 123
        body_double = double(id: fake_c2_proposal_id)
        response_double = double(body: body_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post)
          .with('proposals', fake_c2_attributes)
          .and_return(response_double)

        CreateC2Proposal.new(auction).perform

        expect(c2_client_double).to have_received(:post).with('proposals', fake_c2_attributes)
        expect(auction.c2_proposal_url).to include("proposals/#{fake_c2_proposal_id}")
        expect(auction.c2_proposal_url).to be_url
      end

      it 'updates the auction with the c2_proposal' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        fake_c2_attributes = { fake_c2: 'fake' }
        attributes_double = double(perform: fake_c2_attributes)
        allow(ConstructC2Attributes).to receive(:new).with(auction).and_return(attributes_double)

        fake_c2_proposal_id = 123
        body_double = double(id: fake_c2_proposal_id)
        response_double = double(body: body_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post)
          .with('proposals', fake_c2_attributes)
          .and_return(response_double)

        expect do
          CreateC2Proposal.new(auction).perform
          auction.reload
        end
          .to change { auction.c2_proposal_url }
          .from('')
          .to("https://c2-dev.18f.gov/proposals/#{fake_c2_proposal_id}")
      end
    end

    context 'when the C2 API is failing' do
      it 'raises a CreateC2Proposal::Error' do
        auction = create(:auction, :with_bidders, :evaluation_needed)

        attributes_double = double(perform: { })
        allow(ConstructC2Attributes).to receive(:new).with(auction).and_return(attributes_double)

        c2_client_double = double
        allow(C2::Client).to receive(:new).and_return(c2_client_double)
        allow(c2_client_double).to receive(:post)
          .with('proposals', { })
          .and_raise(Faraday::ClientError.new(nil, nil))

        c2_proposal = CreateC2Proposal.new(auction)
        expect { c2_proposal.perform }.to raise_error(CreateC2Proposal::Error)
      end
    end
  end
end
