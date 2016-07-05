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

    it 'calls CreateAuctionEndedJob' do
      auction = build(:auction, ended_at: 2.days.from_now)
      create_auction_ended_job_double = double(perform: true)
      allow(CreateAuctionEndedJob).to receive(:new).with(auction).and_return(
        create_auction_ended_job_double
      )

      SaveAuction.new(auction).perform

      expect(create_auction_ended_job_double).to have_received(:perform)
    end
  end
end
