require 'rails_helper'

describe CheckApproval do
  describe '#perform' do
    context 'auction has cap proposal url' do
      context 'auction is not published' do
        context 'c2 proposal is approved' do
          it 'updates the c2_approved_at field' do
            c2_path = "proposals/#{FakeC2Api::PURCHASED_PROPOSAL_ID}"
            auction = create(
              :auction,
              :unpublished,
              cap_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
            )

          CheckApproval.new.perform

          expect(auction.reload.c2_approved_at).not_to be_nil
          end
        end

        context 'c2 proposal is not approved' do
          it 'does not update the c2_approved_at field' do
            c2_path = 'proposals/1234'
            auction = create(
              :auction,
              :unpublished,
              cap_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
            )

            CheckApproval.new.perform

            expect(auction.reload.c2_approved_at).to be_nil
          end
        end

        context 'auction does not have cap proposal url' do
          it 'does not check for approval' do
            create(:auction, :unpublished, cap_proposal_url: '')
            c2_client_double = double
            allow(C2::Client).to receive(:new).and_return(c2_client_double)
            allow(c2_client_double).to receive(:get)

            CheckApproval.new.perform

            expect(c2_client_double).not_to have_received(:get)
          end
        end
      end

      context 'auction is published' do
        it 'does not check for approval' do
          create(:auction, :published)
          c2_client_double = double
          allow(C2::Client).to receive(:new).and_return(c2_client_double)
          allow(c2_client_double).to receive(:get)

          CheckApproval.new.perform

          expect(c2_client_double).not_to have_received(:get)
        end
      end
    end
  end
end
