require 'rails_helper'
require 'swagger'

describe Swagger::Reference do
  let(:swagger_file) { Rails.root.join('spec', 'support', 'fixtures', 'swagger', 'basic_reference.json') }
  let(:swagger) { Swagger::Specification.load_json(swagger_file) }

  describe 'dereference' do
    let(:ref) { swagger.definition("ThingRef") }
    let(:target) { swagger.definition("Thing") }

    it 'should not load the referenced object by default' do
      expect(ref).to be_a(Swagger::Reference)
      expect(ref).to_not be_dereferenced
    end

    it 'should not dereference to load the displayed_type' do
      expect(ref.displayed_type).to eq('<a href="#definition-Thing">Thing</a>')
      expect(ref).to_not be_dereferenced
    end

    it 'should dereference when explicitly called' do
      ref.dereferenced
      expect(ref).to be_dereferenced
    end

    it 'should return the name of the pointer' do
      expect(ref.name).to eq('ThingRef')
      expect(ref).to_not be_dereferenced
    end

    it 'should dereference to return the title' do
      expect(ref.title).to eq(target.title)
      expect(ref).to be_dereferenced
    end

    it 'should dereference to return the description' do
      expect(ref.description).to eq(target.description)
      expect(ref).to be_dereferenced
    end

    it 'should dereference to return the properties' do
      expect(ref.properties.map(&:name)).to eq(target.properties.map(&:name))
      expect(ref).to be_dereferenced
    end
  end
end
