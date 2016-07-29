require 'rails_helper'

describe Api::V0::BusinessDaysController do
  include RequestHelpers

  describe 'GET /business_days' do
    it 'returns the date based on params passed in' do
      friday = Time.local(2016, 07, 22, 4)
      next_friday = "July 29, 2016 01:00:00 PM EDT"

      Timecop.freeze(friday) do
        get(
          api_v0_business_day_path(format: :json),
          { day_count: 5, date: '2016-07-22', time: '1:00 PM' },
          { 'HTTP_ACCEPT' => 'text/x-json' }
        )

        expect(json_response['date']).to eq next_friday
      end
    end
  end
end
