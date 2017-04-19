require 'rails_helper'

describe BudgetForecast do
  describe '#minimum_available_dollars' do
    it 'returns the minimum available dollars for a given month' do
      month = '09'
      Timecop.freeze(Date.parse("2016-#{month}-05"))

      monthly_limit = 100000

      _paid_last_month = [
        create(:auction, :paid, :with_bids, paid_at: 6.days.ago),
        create(:auction, :paid, :with_bids, paid_at: 7.days.ago)
      ]

      paid = [
        create(:auction, :paid, :with_bids, paid_at: 1.day.ago),
        create(:auction, :paid, :with_bids, paid_at: 2.days.ago),
        create(:auction, :paid, :with_bids, paid_at: 3.days.ago)
      ]

      paid_amount = paid
                      .map { |auction| WinningBid.new(auction).find.amount }
                      .inject(:+)

      owed = [
        create(:auction, :payment_needed),
        create(:auction, :payment_needed)
      ]

      owed_amount = owed
                      .map { |auction| WinningBid.new(auction).find.amount }
                      .inject(:+)

      _obligated_next_month = [
        create(:auction, :available, :with_bids, delivery_due_at: 35.days.from_now),
        create(:auction, :available, :with_bids, delivery_due_at: 31.days.from_now)
      ]

      obligated = [
        create(:auction, :available, :with_bids, delivery_due_at: 5.days.from_now),
        create(:auction, :available, :with_bids, delivery_due_at: 6.days.from_now),
        create(:auction, :available, :with_bids, delivery_due_at: 7.days.from_now)
      ]

      obligated_amount = obligated
                          .map { |auction| WinningBid.new(auction).find.amount }
                          .inject(:+)

      minimum_available_dollars = (monthly_limit - (paid_amount +
                                                    owed_amount +
                                                    obligated_amount))

      forecast = BudgetForecast.new(month: month, monthly_limit: monthly_limit)

      expect(forecast.minimum_available_dollars).to eq(minimum_available_dollars)

      Timecop.return
    end
  end
end
