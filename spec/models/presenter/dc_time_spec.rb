require 'rails_helper'

RSpec.describe Presenter::DcTime do
  let(:converter) { Presenter::DcTime.new(time) }
  let(:time) { Chronic.parse("4/1/2001 6:15am").utc }

  it 'should convert it to eastern time' do
    expect(converter.convert).to be_within(1).of(Chronic.parse('4/1/2001 6:15am'))
    expect(converter.convert.zone).to eq('EDT')
  end

  context 'when time is nil' do
    let(:time) { nil }

    it 'should returns nil when time is nil' do
      expect(converter.convert).to eq(nil)
    end
  end
end
