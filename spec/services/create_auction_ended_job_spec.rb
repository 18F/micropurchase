require 'rails_helper'

describe CreateAuctionEndedJob do
  describe '#perform' do
    it 'queues and schedules AuctionEndedJob' do
      auction = create(:auction, ended_at: 2.days.from_now)

      expect { CreateAuctionEndedJob.new(auction).perform }
        .to change { Delayed::Job.count }.by(1)
    end
  end
end
