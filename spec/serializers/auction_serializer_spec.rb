require 'rails_helper'

describe AuctionSerializer do
  describe '#winning_bid' do
    context 'auction has no bids' do
      it 'returns null attributes' do
        auction = create(:auction)

        serializer = AuctionSerializer.new(auction)

        expect(serializer.winning_bid.to_json).to eq(
          WinningBidSerializer.new(NullBid.new).to_json
        )
      end
    end

    context 'auction is available' do
      it 'returns null attributes' do
        auction = create(:auction)
        allow(BiddingStatus).to receive(:new).with(auction).and_return(double(available?: true))

        serializer = AuctionSerializer.new(auction)

        expect(serializer.winning_bid.to_json).to eq(
          WinningBidSerializer.new(NullBid.new).to_json
        )
      end

      context 'auction is over' do
        it 'returns winning bid' do
          auction = create(:auction)
          bid = create(:bid, auction: auction)
          allow(BiddingStatus).to receive(:new).with(auction).and_return(double(available?: false))

          serializer = AuctionSerializer.new(auction)

          expect(serializer.winning_bid.to_json).to eq(
            WinningBidSerializer.new(bid).to_json
          )
        end
      end
    end
  end
end
