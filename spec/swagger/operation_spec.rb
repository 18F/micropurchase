require 'rails_helper'
require 'swagger'

describe Swagger::Operation do
  describe 'unique_key' do
    context 'when the operation has an operationId' do
      it 'should just be the operationId' do
        op = Swagger::Operation.new("/auctions/{id}", 'get', {'operationId' => 'foo'}, nil)
        expect(op.unique_key).to eq('foo')
      end
    end

    context 'when the operation does not have an operationId' do
      it 'should be a combination of the verb and path' do
        op = Swagger::Operation.new("/auctions/{id}", 'get', {}, nil)
        expect(op.unique_key).to eq('get-auctions-id')
      end
    end
  end
end
