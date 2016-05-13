require 'rails_helper'

RSpec.describe VCAPApplication do
  describe '::application_uris' do
    let(:application_uris) { VCAPApplication.application_uris }

    it 'returns an array of application_uris' do
      expect(application_uris).to be_an(Array)
      expect(application_uris).to include('fake_uri.18f.gov')
    end
  end
end
