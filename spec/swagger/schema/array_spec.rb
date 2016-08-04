require 'rails_helper'
require 'swagger'

require 'spec_helper'

describe Swagger::Schema::Array do
  describe '#compact_type' do
    context 'for an array of simple types' do
      let(:array) { Swagger::Schema::Array.new('Name', {'type' => 'array', 'items' => {'type' => 'string'}}, nil) }

      it 'should return a simple string' do
        expect(array.compact_type).to eq('array of string')
      end

    end

    context 'for an array of objects' do
      let(:array) { Swagger::Schema::Array.new('Name', {'type' => 'array', 'items' => {'$ref' => "#\/definitions\/Thing"}}, nil) }

      it 'should not dereference pointers' do
        expect(array.compact_type).to eq('array of Thing')
      end
    end
  end
end
