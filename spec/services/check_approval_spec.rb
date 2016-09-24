require 'rails_helper'

describe CheckApproval do
  describe '#perform' do
    context 'auction has c2 proposal url' do
      context 'c2 proposal url is invalid' do
        it 'does not run a check' do
          auction = build(
            :auction,
            :unpublished,
            c2_proposal_url: "n/a"
          )
          auction.save(validate: false)

          expect do
            CheckApproval.new.perform
          end.not_to raise_error
        end
      end

      context 'auction is not published' do
        context 'c2 proposal is budget_approved' do
          it 'updates the c2_status field' do
            c2_path = "proposals/#{FakeC2Api::PURCHASED_PROPOSAL_ID}"
            auction = create(
              :auction,
              :unpublished,
              c2_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
            )

            CheckApproval.new.perform

            expect(auction.reload.c2_status).to eq 'budget_approved'
          end
        end

        context 'c2 proposal is not budget_approved' do
          it 'does not update the c2_budget_approved_at field' do
            c2_path = 'proposals/1234'
            auction = create(
              :auction,
              :unpublished,
              c2_status: :pending_approval,
              c2_proposal_url: "https://c2-dev.18f.gov/#{c2_path}"
            )

            CheckApproval.new.perform

            expect(auction.reload.c2_status).to eq 'pending_approval'
          end
        end

        context 'auction does not have c2 proposal url' do
          it 'does not check for approval' do
            create(:auction, :unpublished, c2_proposal_url: '')
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
