require 'rails_helper'

describe Percent do
  describe '#to_s' do
    it 'returns the rounded percent for numbers passed in' do
      expect(Percent.new(1, 3).to_s).to eq '33%'
    end
  end
end
