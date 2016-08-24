require 'rails_helper'

describe Statistics::AverageBidsPerAuction do
  describe '#to_s' do
    context 'there are complete and evaluated auctions' do
      it 'returns correct number' do
        create(:auction, :complete_and_successful)

        expect(Statistics::AverageBidsPerAuction.new.to_s).to eq 2
      end
    end

    context 'there are not any complete and evaluated auctions' do
      it 'returns n/a' do
        expect(Statistics::AverageBidsPerAuction.new.to_s).to eq 'n/a'
      end
    end
  end
end
