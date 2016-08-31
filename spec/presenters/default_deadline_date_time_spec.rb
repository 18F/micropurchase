require 'rails_helper'

describe DefaultDeadlineDateTime do
  before(:all) do
    BusinessTime::Config.holidays << Date.parse('2016-09-05')
  end

  describe '#initialize' do
    it 'should be N business days later' do
      t = DcTimePresenter.parse('2016-08-29 15:00')
      expect(DcTimePresenter.convert(t)).to be_within(1).of(t)
      expect(DefaultDeadlineDateTime.new(t, 3).dc_time).to be_within(1).of(Time.parse('2016-09-01 15:00 -0400'))
    end

    it 'should handle holidays correctly' do
      t = DefaultDateTime.new(Time.parse('2016-08-29 15:00 -0400')).convert
      expect(DefaultDeadlineDateTime.new(t, 5).dc_time).to be_within(1).of(Time.parse('2016-09-06 13:00 -0400'))
    end
  end

  describe 'parse' do
    it 'should parse the time in the DC timezone and do the offset' do
      expect(DefaultDeadlineDateTime.parse('2016-08-29 15:00', 3).dc_time).to be_within(1).of(Time.parse('2016-09-01 15:00 -0400'))
    end
  end
end
