require 'rails_helper'

describe Admin::NewAuctionViewModel do
  describe '#date_default' do
    context 'for start' do
      it 'defaults to 5 business days after today' do
        friday = Time.local(2016, 7, 22, 4)
        next_friday = Date.new(2016, 7, 29)

        Timecop.freeze(friday) do
          date = Admin::NewAuctionViewModel.new.date_default('started')

          expect(date).to eq(next_friday)
        end
      end
    end

    context 'for end' do
      it 'defaults to 7 business days after today' do
        friday = Time.local(2016, 7, 22)
        tuesday_after_next = Date.new(2016, 8, 2)

        Timecop.freeze(friday) do
          date = Admin::NewAuctionViewModel.new.date_default('ended')

          expect(date).to eq(tuesday_after_next)
        end
      end
    end

    context 'for delivery' do
      it 'defaults to 12 days after today' do
        friday = Time.local(2016, 7, 22)
        two_weeks_from_tuesday = Date.new(2016, 8, 9)

        Timecop.freeze(friday) do
          date = Admin::NewAuctionViewModel.new.date_default('delivery_due_at')

          expect(date).to eq(two_weeks_from_tuesday)
        end
      end
    end
  end
end
