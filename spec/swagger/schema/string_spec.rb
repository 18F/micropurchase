require 'rails_helper'
require 'swagger'

describe Swagger::Schema::String do
  describe 'displayed_type' do
    it 'should return string' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string'}, nil)
      expect(s.displayed_type).to eq('string')
    end

    it 'should append the format if specified' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string', 'format' => 'email'}, nil)
      expect(s.displayed_type).to eq('string (email)')
    end
  end

  describe 'sample_value' do
    it 'should return a basic string if there is no format' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string'}, nil)
      expect(s.sample_value).to eq('"example"')
    end

    it 'should return a sample date-time' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string', 'format' => 'date-time'}, nil)
      expect(s.sample_value).to eq('"2016-01-01T13:00:00Z"')
    end

    it 'should return a sample email' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string', 'format' => 'email'}, nil)
      expect(s.sample_value).to eq('"user@example.com"')
    end

    it 'should return a markdown example' do
      s = Swagger::Schema::String.new('foo', {'type' => 'string', 'format' => 'markdown'}, nil)
      expect(s.sample_value).to eq('"A **markdown** string"')
    end
  end

end
