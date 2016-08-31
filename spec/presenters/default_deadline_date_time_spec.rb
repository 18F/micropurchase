require 'rails_helper'

describe DefaultDeadlineDateTime do
  describe '#initialize' do
    it 'should be N business days later' do
      time = DcTimePresenter.parse('2016-08-29 15:00')
      expect(DefaultDeadlineDateTime.new(start_time: time, day_offset: 3).dc_time).to be_within(0.1).of(Time.parse('2016-09-01 15:00 -0400'))
    end

    it 'should handle holidays correctly' do
      BusinessTime::Config.holidays << Date.parse('2016-09-05')
      time = DefaultDateTime.new(Time.parse('2016-08-29 15:00 -0400')).convert
      expect(DefaultDeadlineDateTime.new(start_time: time, day_offset: 5).dc_time).to be_within(0.1).of(Time.parse('2016-09-06 13:00 -0400'))
    end
  end
end
