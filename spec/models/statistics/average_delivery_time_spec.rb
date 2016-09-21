require 'rails_helper'

describe Statistics::AverageDeliveryTime do
  describe '#to_s' do
    context 'no accepted auctions' do
      it 'returns n/a' do
        expect(Statistics::AverageDeliveryTime.new.to_s).to eq 'n/a'
      end
    end

    context 'accepted auctions' do
      it 'returns average time between end date and accepted_at date' do
        _auction_accepted_after_6_days = create(
          :auction,
          delivery_status: :accepted,
          ended_at: 6.days.ago,
          delivery_due_at: 3.days.ago,
          accepted_at: Time.current
        )
        _auction_accepted_after_2_days = create(
          :auction,
          delivery_status: :accepted,
          ended_at: 4.days.ago,
          delivery_due_at: 1.day.ago,
          accepted_at: 2.days.ago
        )

        expect(Statistics::AverageDeliveryTime.new.to_s).to eq '4 days'
      end
    end
  end
end
