require 'rails_helper'

describe UpdateAuction do
  describe '#perform' do
    context 'when changing ended_at' do
      context 'job not enqueued' do
        it 'creates the Auction Ended Job' do
          auction = create(:auction, :delivery_due_at_expired)
          create_auction_ended_job_double = double(perform: true)
          allow(CreateAuctionEndedJob).to receive(:new).with(auction).and_return(
            create_auction_ended_job_double
          )

          new_ended_at = {
            'ended_at' => '2016-10-26',
            'ended_at(1i)' => '01',
            'ended_at(2i)' => '15',
            'ended_at(3i)' => 'PM'
          }
          params = { auction: new_ended_at}

          UpdateAuction.new(
            auction: auction,
            params: params,
            current_user: auction.user
          ).perform

          expect(create_auction_ended_job_double).to have_received(:perform)
        end
      end
      context 'job already enqueued' do
        it 'updates the AuctionEndedJob to run_at the new ended_at' do
          auction = build(:auction, :delivery_due_at_expired)
          SaveAuction.new(auction).perform
          job = Delayed::Job.first

          new_ended_at = {
            'ended_at' => '2016-10-26',
            'ended_at(1i)' => '01',
            'ended_at(2i)' => '15',
            'ended_at(3i)' => 'PM'
          }
          parsed_new_ended_at = DateTimeParser.new(new_ended_at, 'ended_at').parse
          params = { auction: new_ended_at}

          expect(job.run_at).to eq(auction.ended_at)
          UpdateAuction.new(
            auction: auction,
            params: params,
            current_user: auction.user
          ).perform

          job.reload
          expect(job.run_at).to eq(parsed_new_ended_at)
        end
      end
    end

    context 'when changing the title' do
      it 'updates the title' do
        auction = create(:auction, :delivery_due_at_expired)
        new_title = 'The New Title'
        params = { auction: { title: new_title } }

        updater = UpdateAuction.new(auction: auction, params: params, current_user: auction.user)

        expect { updater.perform }.to change { auction.title }.to(new_title)
      end
    end

    context 'result is set to accepted' do
      context 'auction is below the micropurchase threshold' do
        it 'calls the AcceptAuction' do
          auction = create(
            :auction,
            :below_micropurchase_threshold,
            :winning_vendor_is_small_business,
            :delivery_due_at_expired
          )
          accept_double = double(perform: true)
          allow(AcceptAuction).to receive(:new).
            with(auction: auction, credit_card_form_url: "https://some-website.com/pay").
            and_return(accept_double)
          params = { auction: { result: 'accepted' } }

          UpdateAuction.new(auction: auction, params: params, current_user: auction.user).perform

          expect(accept_double).to have_received(:perform)
        end
      end

      context 'auction is between micropurchase and SAT threshold' do
        context 'winning vendor is a small business' do
          it 'calls the UpdateC2ProposalJob' do
            auction = create(
              :auction,
              :between_micropurchase_and_sat_threshold,
              :winning_vendor_is_small_business,
              :delivery_due_at_expired
            )
            accept_double = double(perform: true)
            allow(AcceptAuction).to receive(:new).
              with(auction: auction, credit_card_form_url: "https://some-website.com/pay").
              and_return(accept_double)
            params = { auction: { result: 'accepted' } }

            UpdateAuction.new(auction: auction, params: params, current_user: auction.user).perform

            expect(accept_double).to have_received(:perform)
          end
        end

        context 'winning vendor is not a small business' do
          it 'does not call the AcceptAuction' do
            auction = create(
              :auction,
              :between_micropurchase_and_sat_threshold,
              :winning_vendor_is_non_small_business,
              :delivery_due_at_expired
            )
            accept_double = double(perform: true)
            allow(AcceptAuction).to receive(:new).
              with(auction: auction, credit_card_form_url: "https://some-website.com/pay").
              and_return(accept_double)
            params = { auction: { result: 'accepted' } }

            UpdateAuction.new(auction: auction, params: params, current_user: auction.user).perform

            expect(accept_double).not_to have_received(:perform)
          end
        end
      end
    end

    context 'when result is set to rejected' do
      it 'sets rejected_at to the time the auction was rejected' do
        auction = create(:auction, :delivery_due_at_expired)
        params = { auction: { result: 'rejected' } }

        updater = UpdateAuction.new(auction: auction, params: params, current_user: auction.user)

        expect { updater.perform }.to change { auction.rejected_at }
      end

      it 'does not set c2_proposal_url' do
        auction = create(:auction, :delivery_due_at_expired)
        params = { auction: { result: 'rejected' } }

        updater = UpdateAuction.new(auction: auction, params: params, current_user: auction.user)

        expect { updater.perform }.to_not change { auction.c2_proposal_url }
        expect(auction.c2_proposal_url).to eq ""
      end

      it 'does not call AcceptAuction' do
        auction = create(:auction, :delivery_due_at_expired)
        params = { auction: { result: 'rejected' } }
        accept_double = double(perform: true)
        allow(AcceptAuction).to receive(:new).with(auction: auction, credit_card_form_url: "https://some-website.com/pay" ).and_return(accept_double)

        UpdateAuction.new(auction: auction, params: params, current_user: auction.user)

        expect(accept_double).to_not have_received(:perform)
      end
    end
  end
end
