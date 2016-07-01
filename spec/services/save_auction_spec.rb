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

    it 'queues and schedules AuctionEndedJob' do
      auction = build(:auction, ended_at: 2.days.from_now)

      expect { SaveAuction.new(auction).perform }
        .to change { Delayed::Job.count }.by(1)
    end
  end
end
