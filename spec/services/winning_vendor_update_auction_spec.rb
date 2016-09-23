require 'rails_helper'

describe WinningVendorUpdateAuction do
  describe '#perform' do
    context 'user is winning bidder' do
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
