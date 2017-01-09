require 'rails_helper'

describe 'SLO' do
  before do
    OmniAuth.config.test_mode = false
  end

  def login
    get '/auth/saml'
    idp_uri = URI(response.headers['Location'])
    saml_idp_resp = Net::HTTP.get(idp_uri)
    post '/auth/saml/callback', SAMLResponse: saml_idp_resp
  end

  describe 'IdP-initiated' do
    it 'uses external SAML IdP' do
      # ask the IdP to initiate a SLO
      idp_uri = URI('http://idp.example.com/saml/logout')
      saml_idp_resp = Net::HTTP.get(idp_uri)

      # send the SAMLRequest to our logout endpoint
      post '/auth/saml/logout', SAMLRequest: saml_idp_resp, RelayState: 'the_idp_session_id'

      # redirect to complete the sign-out at the IdP
      expect(response).to redirect_to(%r{idp.example.com/saml/logout})
    end
  end

  describe 'SP-initiated' do
    it 'uses external SAML IdP' do
      # must login since we cannot mock session in request spec
      login

      # ask the SP to initiate a SLO
      delete '/auth/saml/logout'

      expect(response).to redirect_to(%r{idp.example.com/saml/logout})

      # send the SAMLRequest to IdP
      idp_uri = URI(response.headers['Location'])
      saml_idp_resp = Net::HTTP.get(idp_uri)

      # send the SAMLResponse back to our SP
      post '/auth/saml/logout', SAMLResponse: saml_idp_resp

      # expect we are logged out, on our site
      expect(response).to redirect_to(root_url)
      expect(flash[:notice]).to eq I18n.t('omniauth_callbacks.logout_ok')
    end
  end
end
