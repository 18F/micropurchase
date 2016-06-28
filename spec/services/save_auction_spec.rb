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

      it 'queues and schedules AuctionEndedJob' do
        auction = build(:auction, ended_at: 2.days.from_now)

        expect { SaveAuction.new(auction).perform }
          .to change { Delayed::Job.count }.by(1)

        job = Delayed::Job
                .where(queue: 'auction_ended')
                .where(auction_id: auction.id)
                .first

        expect(job.run_at).to eq(auction.ended_at)
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
      it 'queues and schedules AuctionEndedJob#perform' do
        auction = build(:auction, ended_at: 2.days.from_now)

        expect { SaveAuction.new(auction).perform }
          .to change { Delayed::Job.count }.by(1)

        SaveAuction.new(auction).perform
      end
    end

    context 'not setting auction.ended_at' do
      it 'does not queue and schedule AuctionEndedJob#perform' do
        auction = build(:auction, ended_at: nil)

        expect { SaveAuction.new(auction).perform }
          .not_to change { Delayed::Job.count }
      end
    end
  end
end
