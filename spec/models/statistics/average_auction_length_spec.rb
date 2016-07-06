require 'rails_helper'

describe Statistics::AverageAuctionLength do
  describe '#to_s' do
    context 'there are completed auctions' do
      it 'returns correct number' do
        create(
          :auction,
          :complete_and_successful,
          started_at: 3.days.ago,
          ended_at: Time.current
        )

        expect(Statistics::AverageAuctionLength.new.to_s).to eq "3 days"
      end
    end

    context 'there are not any completed auctions' do
      it 'returns n/a' do
        expect(Statistics::AverageAuctionLength.new.to_s).to eq "n/a"
      end
    end
  end
end
