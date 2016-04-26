require 'rails_helper'

describe Presenter::DcTime do
  describe '#convert' do
    context 'when it is a time' do
      it 'should convert it to eastern time' do
        time = DateTime.parse("2001-04-01 16:15:00")
        converter = Presenter::DcTime.new(time)
        expect(converter.convert.zone).to eq('EDT')
      end
    end

    context 'when time is nil' do
      it 'should returns nil when time is nil' do
        time = nil
        converter = Presenter::DcTime.new(time)
        expect(converter.convert).to eq(nil)
      end
    end
  end

  describe '#convert_and_format' do
    context 'when nil' do
      it 'should return a non breaking space' do
        time = nil
        converter = Presenter::DcTime.new(time)
        expect(converter.convert_and_format).to eq('&nbsp;')
      end
    end

    context 'when it is a time' do
      it 'should convert to a reasonable string' do
        time = DateTime.parse("2001-04-01 06:30:00")
        converter = Presenter::DcTime.new(time)
        expect(converter.convert_and_format).to eq("April 01, 2001 01:30:00 AM")
      end
    end
  end
end
