require 'rails_helper'
require 'swagger'

describe Swagger::Schema::Number do
  describe 'displayed_type' do
    it 'should just be the display type' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'integer' }, nil)
      expect(s.displayed_type).to eq('integer')
    end

    it 'should include an exclusiveMinimum if specified' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'integer', 'exclusiveMinimum' => true, 'minimum' => 0 }, nil)
      expect(s.displayed_type).to eq('integer (n > 0)')
    end

    it 'should include an exclusiveMaximum if specified' do
      options = {
        'type' => 'integer',
        'exclusiveMaximum' => true,
        'maximum' => 3500
      }
      s = Swagger::Schema::Number.new('foo', options, nil)
      expect(s.displayed_type).to eq('integer (n < 3500)')
    end

    it 'should include a minimum if specified' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'integer', 'minimum' => 0 }, nil)
      expect(s.displayed_type).to eq('integer (n >= 0)')
    end

    it 'should include a maximum if specified' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'integer', 'maximum' => 3500 }, nil)
      expect(s.displayed_type).to eq('integer (n <= 3500)')
    end

    it 'should combine maximum and minimums' do
      options = {
        'type' => 'integer',
        'maximum' => 3500,
        'exclusiveMinimum' => true,
        'minimum' => 0
      }
      s = Swagger::Schema::Number.new('foo', options, nil)
      expect(s.displayed_type).to eq('integer (0 < n <= 3500)')
    end
  end

  describe 'sample_value' do
    it 'should be an integer for integer' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'integer' }, nil)
      expect(s.sample_value).to eq(39)
    end

    it 'should be a float for float' do
      s = Swagger::Schema::Number.new('foo', { 'type' => 'number' }, nil)
      expect(s.sample_value).to eq(39.4)
    end
  end
end
