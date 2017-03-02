require 'rails_helper'

describe 'SLO' do
  before do
    OmniAuth.config.test_mode = false
  end

  def login
    get '/auth/saml'
    idp_uri = URI(response.headers['Location'])
    saml_idp_resp = Net::HTTP.get(idp_uri)
    saml_response = OneLogin::RubySaml::Response.new(saml_idp_resp)
    uid = saml_response.attributes['uid']
    _admin_user = create(:admin_user, uid: uid)
    post '/auth/saml/callback', SAMLResponse: saml_idp_resp
  end

  describe 'IdP-initiated' do
    it 'uses external SAML IdP' do
      # ask the IdP to initiate a SLO
      idp_uri = URI('http://idp.example.com/api/saml/logout')
      saml_idp_resp = Net::HTTP.get(idp_uri)

      # send the SAMLRequest to our logout endpoint
      post '/auth/saml/logout', SAMLRequest: saml_idp_resp, RelayState: 'the_idp_session_id'

      # redirect to complete the sign-out at the IdP
      expect(response).to redirect_to(%r{idp.example.com/api/saml/logout})
    end
  end

  describe 'SP-initiated' do
    it 'uses external SAML IdP' do
      # must login since we cannot mock session in request spec
      login

      # ask the SP to initiate a SLO
      delete '/auth/saml/logout'

      # redirects to the fake idp
      expect(response).to redirect_to(%r{idp.example.com/api/saml/logout})

      # send the SAMLRequest to fake IdP
      # gets url from response
      idp_uri = URI(response.headers['Location'])
      saml_idp_resp = Net::HTTP.get(idp_uri)

      # send the SAMLResponse back to our SP
      post '/auth/saml/logout', SAMLResponse: saml_idp_resp

      # expect we are logged out, on our site
      expect(response).to redirect_to(root_url)
      expect(flash[:notice]).to eq I18n.t('omniauth_callbacks.logout_ok')
    end
  end

  describe 'failure' do
    it 'returns error' do
      post '/auth/saml/logout', SAMLResponse: 'test'

      expect(flash[:alert]).to eq I18n.t('omniauth_callbacks.logout_fail')
    end
  end
end
