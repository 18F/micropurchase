require 'rails_helper'

RSpec.describe Presenter::DcTime do
  let(:converter) { Presenter::DcTime.new(time) }
  let(:time) { Chronic.parse("4/1/2001 6:15am").utc }

  describe '#convert' do
    context 'when it is a time' do
      it 'should convert it to eastern time' do
        expect(converter.convert).to be_within(1).of(Chronic.parse('4/1/2001 6:15am'))
        expect(converter.convert.zone).to eq('EDT')
      end
    end

    context 'when time is nil' do
      let(:time) { nil }

      it 'should returns nil when time is nil' do
        expect(converter.convert).to eq(nil)
      end
    end
  end

  describe '#convert_and_format' do
    context 'when nil' do
      let(:time) { nil }

      it 'should return a non breaking space' do
        expect(converter.convert_and_format).to eq('&nbsp;')
      end
    end

    context 'when it is a time' do
      it 'should convert to a reasonable string' do
        expect(converter.convert_and_format).to eq("April 01, 2001 06:15:00 AM")
      end
    end
  end
end
