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
end
