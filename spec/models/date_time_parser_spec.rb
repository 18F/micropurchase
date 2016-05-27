require 'rails_helper'

describe DateTimeParser do
  describe '#parse' do
    it 'returns an EST datetime based on attrs passed in' do
      fake_date = "2016-05-26"
      fake_hour = "01"
      fake_minute = "15"
      fake_meridiem = "PM"

      params = {
        'fake_at' => fake_date,
        'fake_at(1i)' => fake_hour,
        'fake_at(2i)' => fake_minute,
        'fake_at(3i)' => fake_meridiem
      }

      parsed = DateTimeParser.new(params, 'fake_at').parse

      expect(parsed).to be_an(ActiveSupport::TimeWithZone)
      expect(parsed).to eq(Time.parse("2016-05-26 13:15-04:00"))
    end
  end
end
