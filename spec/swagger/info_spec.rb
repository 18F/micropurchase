require 'rails_helper'
require 'swagger'

describe Swagger::Info do
  let(:swagger_path) { Rails.root.join('spec', 'support', 'fixtures', 'swagger', 'info_sample.json') }
  let(:swagger) { Swagger::Specification.load_json(swagger_path) }
  let(:info) { swagger.info }

  it 'should load the info object' do
    expect(info).to_not be_nil

    expect(info.title).to eq('Swagger Sample App')
    expect(info.description).to eq('This is a sample server Petstore server.')
    expect(info.terms_of_service).to eq('http://swagger.io/terms/')
    expect(info.version).to eq('1.0.1')
  end

  it 'should return contact fields' do
    expect(info.contact_name).to eq('API Support')
    expect(info.contact_url).to eq('http://www.swagger.io/support')
    expect(info.contact_email).to eq('support@swagger.io')
  end

  it 'should return license fields' do
    expect(info.license_name).to eq('Apache 2.0')
    expect(info.license_url).to eq('http://www.apache.org/licenses/LICENSE-2.0.html')
  end
end
