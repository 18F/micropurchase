require 'rails_helper'

describe CreateAuctionEndedJob do
  describe '#perform' do
    it 'queues and schedules AuctionEndedJob' do
      auction = create(:auction, ended_at: 2.days.from_now)

      expect { CreateAuctionEndedJob.new(auction).perform }
        .to change { Delayed::Job.count }.by(1)
    end

    context 'auction is closed' do
      it 'does not enqueue a job' do
        auction = create(:auction, ended_at: 2.days.ago)

        expect { CreateAuctionEndedJob.new(auction).perform }
          .to change { Delayed::Job.count }.by(0)
      end
    end
  end
end
