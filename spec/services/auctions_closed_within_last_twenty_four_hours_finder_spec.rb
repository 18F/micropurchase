require 'rails_helper'

describe AuctionsClosedWithinLastTwentyFourHoursFinder do
  describe '#perform' do
    it 'returns auctions with an end datetime that occured today' do
      Timecop.freeze(Time.parse("19:00:00 UTC")) do
        _old_auction = create(:auction, ended_at: 2.days.ago)
        newly_closed_auction = create(:auction, ended_at: 2.hours.ago)
        _future_auction = create(:auction, ended_at: 2.days.from_now)

        expect(AuctionsClosedWithinLastTwentyFourHoursFinder.new.perform).to eq [newly_closed_auction]
      end
    end
  end
end
