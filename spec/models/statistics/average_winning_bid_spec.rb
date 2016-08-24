require 'rails_helper'

describe Statistics::AverageWinningBid do
  describe '#to_s' do
    context 'there are complete and evaluated auctions' do
      it 'returns correct amount' do
        auction = create(:auction, :complete_and_successful)
        create(:bid, amount: 3, auction: auction)

        expect(Statistics::AverageWinningBid.new.to_s).to eq "$3.00"
      end
    end

    context 'there are not any complete and evaluated auctions' do
      it 'returns n/a' do
        expect(Statistics::AverageWinningBid.new.to_s).to eq 'n/a'
      end
    end
  end
end
