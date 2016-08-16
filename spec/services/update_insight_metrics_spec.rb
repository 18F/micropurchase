require 'rails_helper'

describe UpdateInsightMetrics do
  describe '#perform' do
    context 'metric does not exist yet' do
      it 'creates the metric' do
        UpdateInsightMetrics.new.perform

        metric = InsightMetric.find_by(name: 'average_auction_length')

        expect(metric.statistic).to eq 'n/a'
      end
    end

    context 'metric does exist' do
      it 'updates the metric' do
        create(
          :auction,
          :complete_and_successful,
          started_at: 3.days.ago,
          ended_at: Time.current
        )
        InsightMetric.create(
          name: 'average_auction_length',
          label: 'average auction length',
          statistic: 'n/a'
        )

        UpdateInsightMetrics.new.perform

        metric = InsightMetric.find_by(name: 'average_auction_length')

        expect(metric.statistic).to eq '3 days'
      end
    end
  end
end
