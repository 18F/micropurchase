require 'rails_helper'

describe DateTimeParser do
  describe '#parse' do
    it 'returns a datetime based on attrs passed in' do
      fake_date = "2016-05-26"
      fake_hour = "01"
      fake_minute = "15"
      fake_meridien = "AM"

      params = {
        'fake_at' => fake_date,
        'fake_at(1i)' => fake_hour,
        'fake_at(2i)' => fake_minute,
        'fake_at(3i)' => fake_meridien
      }

      parsed = DateTimeParser.new(params, 'fake_at').parse

      expect(parsed).to be_a(DateTime)
    end
  end
end
