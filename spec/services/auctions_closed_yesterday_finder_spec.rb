require 'rails_helper'

describe AuctionsClosedYesterdayFinder do
  describe '#perform' do
    it 'returns auctions with an end datetime that occured yesterday' do
      Timecop.freeze(Time.parse("03:00:00 UTC")) do
        _old_auction = create(:auction, end_datetime: 2.days.ago)
        newly_closed_auction = create(:auction, end_datetime: 5.hours.ago)
        _future_auction = create(:auction, end_datetime: 2.days.from_now)

        expect(AuctionsClosedYesterdayFinder.new.perform).to eq [newly_closed_auction]
      end
    end
  end
end
