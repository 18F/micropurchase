require 'rails_helper'

describe DcTimePresenter do
  describe '#convert' do
    context 'when it is a time' do
      it 'should convert it to eastern time' do
        time = Chronic.parse("4/1/2001 6:15am").utc
        converter = DcTimePresenter.new(time)
        expect(converter.convert).to be_within(1).of(Chronic.parse('4/1/2001 6:15am'))
        expect(converter.convert.zone).to eq('EDT')
      end
    end

    context 'when time is nil' do
      it 'should returns nil when time is nil' do
        converter = DcTimePresenter.new(nil)
        expect(converter.convert).to eq(nil)
      end
    end

    context 'when it is already in the DC timezone' do
      it 'should stay in the DC timezone' do
        time = Time.parse('2016-09-01 13:00 -04:00')
        converter = DcTimePresenter.new(time)
        c = converter.convert
        expect(c.to_s).to eq(Time.parse('2016-09-01 13:00 -04:00').to_s)
        expect(c.zone).to eq('EDT')
      end
    end
  end

  describe '#convert_and_format' do
    context 'when nil' do
      it 'should return a non breaking space' do
        converter = DcTimePresenter.new(nil)
        expect(converter.convert_and_format).to eq('&nbsp;')
      end
    end

    context 'when it is a time' do
      it 'should convert to a reasonable string' do
        time = Chronic.parse("4/1/2001 6:15am").utc
        converter = DcTimePresenter.new(time)
        expect(converter.convert_and_format).to eq("April 01, 2001 06:15:00 AM EDT")
      end

      context 'when we are in daylight saving time' do
        it 'should handle daylight saving time correctly' do
          time = Chronic.parse('12/1/2010 6:15am').utc
          converter = DcTimePresenter.new(time)

          expect(converter.convert_and_format).to eq("December 01, 2010 06:15:00 AM EST")
        end
      end
    end
  end

  describe '#relative_time' do
    it 'should return "in N minutes" for <60 minutes from now' do
      Timecop.freeze do
        time = Time.now + 23.minutes
        expect(DcTimePresenter.new(time).relative_time).to eq("in 23 minutes")
      end
    end

    it 'should return "in N hours" for <24 hours from now' do
      Timecop.freeze do
        time = Time.now + 200.minutes
        expect(DcTimePresenter.new(time).relative_time).to eq("in 3 hours")
      end
    end

    it 'should return "on DATE at TIME" for < 24 hours from now' do
      time = Time.parse('2016-09-01 13:00 -0400')
      expect(DcTimePresenter.new(time).relative_time).to eq('on Sep 1, 2016 at 1:00 PM EDT')
    end

    it 'should return "N minutes ago" for <60 minutes ago' do
      Timecop.freeze do
        time = Time.now - 1.minute
        expect(DcTimePresenter.new(time).relative_time).to eq("1 minute ago")
      end
    end

    it 'should return "N hours ago" for <24 hours ago' do
      Timecop.freeze do
        time = Time.now - 330.minutes
        expect(DcTimePresenter.new(time).relative_time).to eq("5 hours ago")
      end
    end
  end
end
