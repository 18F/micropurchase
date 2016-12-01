require 'rails_helper'
require 'swagger'

describe Swagger::Schema::Object do
  let(:object) { Swagger::Schema::Object.new('Name', { "description" => 'description', "title" => 'title' }, nil) }

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

  describe '#displayed_type' do
    it 'should link the object name to its definition' do
      expect(object.displayed_type).to eq('<a href="#definition-Name">Name</a>')
    end
  end
end
