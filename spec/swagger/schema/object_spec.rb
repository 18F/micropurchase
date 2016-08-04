require 'rails_helper'
require 'swagger'

describe Swagger::Schema::Object do
  let(:object) { Swagger::Schema::Object.new('Name', {"description" => 'description', "title" => 'title'}, nil) }

  describe '#title' do
    it 'should return the title of the object' do
      expect(object.title).to eq('title')
    end
  end

  describe '#description' do
    it 'should return the description the object' do
      expect(object.description).to eq('description')
    end
  end

  describe '#sample_value' do
    it "should return ''" do
      expect(object.sample_value).to eq('')
    end
  end

  describe '#compact_type' do
    context 'when an object has no properties' do
      it 'should display the object name' do
        expect(object.compact_type).to eq('Name')
      end
    end

    # context 'when an object has only 2 properties or less' do
    #   let(:object) { Swagger::Schema::Object.new('Name', {'properties' => {
    #                                                               "foo" => {"type" => "string"},
    #                                                               "bar" => {"type" => "integer"}}},
    #                                              nil)}

    #   it 'should display them inline within braces' do
    #     expect(object.compact_type).to eq('<Name {"foo": string, "bar": integer}>')
    #   end
    # end

    # context 'when an object has more than 2 properties' do
    #   let(:object) { Swagger::Schema::Object.new('Name', {'properties' => {
    #                                                               "foo" => {"type" => "string"},
    #                                                               "bar" => {"type" => "integer"},
    #                                                               "baz" => {"type" => "string"}}},
    #                                              nil)}

    #   it 'should just display the name' do
    #     expect(object.compact_type).to eq('<Name object>')
    #   end
    # end
  end
end
