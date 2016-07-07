require 'rails_helper'

describe Statistics::AverageStartingPrice do
  describe '#to_s' do
    context 'there are completed auctions' do
      it 'returns average starting price of completed auctions' do
        create(:auction, :complete_and_successful, start_price: 100)
        create(:auction, :complete_and_successful, start_price: 200)
        create(:auction, :unpublished, start_price: 100)

        expect(Statistics::AverageStartingPrice.new.to_s).to eq "$150.00"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(Statistics::AverageStartingPrice.new.to_s).to eq 'n/a'
      end
    end
  end
end
