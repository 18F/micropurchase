require 'rails_helper'
require 'swagger'

require 'spec_helper'

describe Swagger::Schema::Array do
  describe '#displayed_type' do
    it 'for an array of simple types should return a simple string' do
      options = { 'type' => 'array', 'items' => { 'type' => 'string' } }
      array = Swagger::Schema::Array.new('Name', options, nil)
      expect(array.displayed_type).to eq('array of string')
    end

    it 'for an array of objects should not dereference pointers' do
      options = { 'type' => 'array', 'items' => { '$ref' => "#\/definitions\/Thing" } }
      array = Swagger::Schema::Array.new('Name', options, nil)
      expect(array.displayed_type).to eq('array of <a href="#definition-Thing">Thing</a>')
    end
  end
end
