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
        saved = SaveAuction.new(auction).perform

        expect(saved).to be(false)
      end
    end
  end
end
