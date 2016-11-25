require 'rails_helper'
require 'swagger'

describe Swagger::Schema::AllOf do
  let(:swagger_path) { Rails.root.join('spec', 'support', 'fixtures', 'swagger', 'basic_reference.json') }
  let(:swagger) { Swagger::Specification.load_json(swagger_path) }
  let(:all_of) { swagger.definition("AllOfThing") }

  describe 'properties' do
    it 'should concatenate properties from its members' do
      properties = all_of.properties
      expect(properties.map(&:name)).to eq(%w(name numbers added_field))
    end
  end
end
