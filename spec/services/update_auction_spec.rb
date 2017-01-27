require 'rails_helper'

describe UpdateAuction do
  describe '#perform' do
    context 'when archiving an auction' do
      context 'when there is no associated auction_state' do
        it 'creates a new AuctionState and sets value to archived' do
          auction = create(:auction, :unpublished)

          params = {
            auction: {"foo" => "bar"},
            archive_auction: :Archive
          }

          expect do
            UpdateAuction.new(
              auction: auction,
              params: params,
              current_user: auction.user
            ).perform
          end.to change { AuctionState.count }.by(1)

          auction.reload

          published_state = auction.states.find {|state| state.name == 'published'}
          expect(published_state.state_value).to eq('archived')
        end
      end

      context 'when there is an associated auction_state' do
        it 'updates the AuctionState and sets value to archived' do
          auction = create(:auction, :unpublished)

          # adding the existing auction_state
          # not using a factory since we want to use less of them
          # this could eventually be pulled into a builder class/method
          auction.states.build(name: 'published', state_value: 'unpublished')
          auction.save

          params = {
            auction: {"foo" => "bar"},
            archive_auction: :Archive
          }

          expect do
            UpdateAuction.new(
              auction: auction,
              params: params,
              current_user: auction.user
            ).perform
          end.to change { AuctionState.count }.by(0)

          auction.reload

          published_state = auction.states.find {|state| state.name == 'published'}
          expect(published_state.state_value).to eq('archived')
        end
      end
    end

    context 'when publishing an auction' do
      it 'creates an AuctionState record' do
        auction = create(:auction, :unpublished)

        params = {
          auction: {"published" => "published"}
        }

        UpdateAuction.new(
          auction: auction,
          params: params,
          current_user: auction.user
        ).perform

        auction.reload

        published_state = auction.states.find {|state| state.name == 'published'}
        expect(published_state.state_value).to eq('published')
      end
    end

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
          params = { auction: new_ended_at }

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
          Timecop.freeze(Time.local(2016)) do
            auction = build(:auction)
            SaveAuction.new(auction).perform
            job = Delayed::Job.first

            new_ended_at = {
              'ended_at' => '2016-10-26',
              'ended_at(1i)' => '01',
              'ended_at(2i)' => '15',
              'ended_at(3i)' => 'PM'
            }
            parsed_new_ended_at = DateTimeParser.new(new_ended_at, 'ended_at').parse
            params = { auction: new_ended_at }

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
    end

    context 'when setting c2_proposal_url and c2_status manually' do
      it 'should set the c2_proposal_url and c2_status' do
        auction = create(:auction, c2_status: :sent)
        c2_proposal_url = 'https://c2-dev.18f.gov/proposals/2486'
        params = { auction: { c2_proposal_url: c2_proposal_url, c2_status: 'pending_approval' } }

        UpdateAuction.new(
          auction: auction,
          params: params,
          current_user: auction.user
        ).perform

        auction.reload
        expect(auction.c2_proposal_url).to eq(c2_proposal_url)
        expect(auction.c2_status).to eq('pending_approval')
      end
    end

    context 'when changing the title' do
      it 'updates the title' do
        auction = create(:auction, :delivery_due_at_expired)
        new_title = 'The New Title'
        params = { auction: { title: new_title } }

        expect do
          UpdateAuction.new(
            auction: auction,
            params: params,
            current_user: auction.user
          ).perform
        end.to change { auction.title }.to(new_title)
      end
    end
  end
end
