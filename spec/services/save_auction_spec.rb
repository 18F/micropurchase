require 'rails_helper'

describe SaveAuction do
  describe '#perform' do
    context 'given a valid auction' do
      it 'saves the auction' do
        auction = build(:auction)
        SaveAuction.new(auction).perform

        expect(auction).to be_persisted
      end

      it 'returns true' do
        auction = build(:auction)
        saved = SaveAuction.new(auction).perform

        expect(saved).to eq true
      end
    end

    context 'given an invalid auction' do
      it 'is not persisted' do
        auction = build(:auction, title: nil)
        SaveAuction.new(auction).perform

        expect(auction).to_not be_persisted
      end

      it 'returns false' do
        auction = build(:auction, title: nil)
        SaveAuction.new(auction).perform

        expect(auction).not_to be_persisted
      end
    end

    context 'setting auction.ended_at' do
      it 'queues and schedules AuctionEnded#perform' do
        auction = build(:auction, ended_at: 2.days.from_now)

        auction_ended_double = instance_double("AuctionEnded")
        allow(AuctionEnded).to receive(:new)
          .with(auction)
          .and_return(auction_ended_double)

        delayed_double = double
        allow(delayed_double).to receive(:perform)

        allow(auction_ended_double).to receive(:delay)
          .with(run_at: auction.ended_at)
          .and_return(delayed_double)

        expect(auction_ended_double).to receive(:delay)
          .with(run_at: auction.ended_at)

        SaveAuction.new(auction).perform
      end
    end

    context 'not setting auction.ended_at' do
      it 'does not queue and schedule AuctionEnded#perform' do
        auction = build(:auction, ended_at: nil)

        expect { SaveAuction.new(auction).perform }
          .not_to change { Delayed::Job.count }
      end
    end
  end
end
