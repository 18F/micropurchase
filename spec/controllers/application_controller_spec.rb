require 'rails_helper'

RSpec.describe ApplicationController, controller: true do
  describe "authenticator" do
    before do
      allow(controller).to receive(:format).and_return(format)
    end

    context 'when the controller receives a web request' do
      let(:format) { double('format', "html?" => true, "json?" => false) }

      it 'should return an instance of WebAuthenticator' do
        expect(controller.send(:authenticator)).to be_a(ApplicationController::WebAuthenticator)
      end
    end

    context 'when the controller receives an API request' do
      let(:format) { double('format', "html?" => false, "json?" => true) }

      it 'should return an instance of ApiAuthenticator' do
        expect(controller.send(:authenticator)).to be_a(ApplicationController::WebAuthenticator)
      end
    end
  end
end
