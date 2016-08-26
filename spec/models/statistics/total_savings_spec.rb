require 'rails_helper'

describe Statistics::TotalSavings do
  describe '#to_s' do
    context 'there are complete and evaluated auctions' do
      it 'returns correct amount' do
        auction = create(:auction, :complete_and_successful, start_price: 10)
        second_auction = create(:auction, :complete_and_successful, start_price: 20)
        create(:bid, amount: 3, auction: auction)
        create(:bid, amount: 3, auction: second_auction)

        expect(Statistics::TotalSavings.new.to_s).to eq '$24.00'
      end
    end

    context 'there are no complete and successful auctions' do
      it 'retrns n/a' do
        create(:auction, :closed, :rejected, :with_bids)
        expect(Statistics::TotalSavings.new.to_s).to eq 'n/a'
      end
    end
  end
end
