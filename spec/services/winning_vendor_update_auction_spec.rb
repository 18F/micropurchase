require 'rails_helper'

describe WinningVendorUpdateAuction do
  describe '#perform' do
    context 'user is winning bidder' do
      context 'when the auction is in progress' do
        context 'when the status is present' do
          it 'sets the Auction to be pending_acceptance' do
            auction = create(:auction, :work_in_progress)
            user = auction.lowest_bid.bidder

            update = WinningVendorUpdateAuction.new(
              auction: auction,
              current_user: user,
              params: { auction: { status: 'pending_acceptance' } }
            ).perform

            auction.reload
            expect(update).to be_truthy
            expect(auction).to be_pending_acceptance
          end

          it 'sets the sends an email to admins that work is finished' do
            auction = create(:auction, :work_in_progress)
            user = auction.lowest_bid.bidder

            mailer_double = double(deliver_later: true)
            allow(AdminMailer).to receive(:vendor_finished_work)
              .with(auction: auction)
              .and_return(mailer_double)

            update = WinningVendorUpdateAuction.new(
              auction: auction,
              current_user: user,
              params: { auction: { status: 'pending_acceptance' } }
            ).perform

            expect(update).to be_truthy
            expect(AdminMailer).to have_received(:vendor_finished_work)
              .with(auction: auction)
            expect(mailer_double).to have_received(:deliver_later)
          end
        end
      end

      context 'when the auction is not marked as a work in progress yet' do
        context 'delivery URL is present' do
          it 'updates the auction with the URL' do
            auction = create(:auction)
            user = create(:user, sam_status: :sam_accepted)
            create(:bid, auction: auction, bidder: user)
            url = 'http://www.example.com'

            update = WinningVendorUpdateAuction.new(
              auction: auction,
              current_user: user,
              params: { auction: { delivery_url: url } }
            ).perform

            expect(update).to eq true
            expect(auction.reload.delivery_url).to eq url
            expect(auction).to be_work_in_progress
          end

          it 'sends an email to admins that work is in progress' do
            auction = create(:auction)
            user = create(:user, sam_status: :sam_accepted)
            create(:bid, auction: auction, bidder: user)
            url = 'http://www.example.com/'

            mailer_double = double(deliver_later: true)
            allow(AdminMailer).to receive(:vendor_started_work)
              .with(auction: auction)
              .and_return(mailer_double)

            WinningVendorUpdateAuction.new(
              auction: auction,
              current_user: user,
              params: { auction: { delivery_url: url } }
            ).perform

            expect(AdminMailer).to have_received(:vendor_started_work)
              .with(auction: auction)
            expect(mailer_double).to have_received(:deliver_later)
          end
        end

        context 'delivery URL is not present' do
          it 'returns false' do
            auction = create(:auction)
            user = create(:user, sam_status: :sam_accepted)
            create(:bid, auction: auction, bidder: user)
            url = ''

            update = WinningVendorUpdateAuction.new(
              auction: auction,
              current_user: user,
              params: { auction: { delivery_url: url } }
            ).perform

            expect(update).to eq false
          end
        end
      end
    end

    context 'user is not winning bidder' do
      it 'returns false' do
        auction = create(:auction)
        user = create(:user, sam_status: :sam_accepted)
        url = 'http://www.example.com'

        update = WinningVendorUpdateAuction.new(
          auction: auction,
          current_user: user,
          params: { auction: { delivery_url: url } }
        ).perform

        expect(update).to eq false
      end
    end

    context 'no current user' do
      it 'returns false' do
        auction = create(:auction)
        url = 'http://www.example.com'

        update = WinningVendorUpdateAuction.new(
          auction: auction,
          current_user: nil,
          params: { auction: { delivery_url: url } }
        ).perform

        expect(update).to eq false
      end
    end
  end
end
