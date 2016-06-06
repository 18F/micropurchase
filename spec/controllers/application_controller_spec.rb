require 'rails_helper'

describe ApplicationController do
  describe "authenticator" do
    context 'API request' do
      it 'should return an instance of ApiAuthenticator' do
        format = double('format', "json?" => true)
        request = double('request', format: format)
        allow(controller).to receive(:request).and_return(request)
        expect(controller.send(:authenticator)).to be_a(ApiAuthenticator)
      end
    end

    context 'non-API request' do
      it 'should return an instance of WebAuthenticator' do
        format = double('format', "json?" => false)
        request = double('request', format: format)
        allow(controller).to receive(:request).and_return(request)
        expect(controller.send(:authenticator)).to be_a(WebAuthenticator)
      end
    end
  end
end
