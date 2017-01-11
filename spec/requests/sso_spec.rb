require 'rails_helper'

describe 'SSO' do
  before do
    OmniAuth.config.test_mode = false
  end

  context 'user is not an admin' do
    it 'does not sign in the user' do
      get '/auth/saml'
      expect(response).to redirect_to(%r{idp\.example\.com\/saml\/auth})

      idp_uri = URI(response.headers['Location'])
      saml_idp_resp = Net::HTTP.get(idp_uri)

      saml_response = OneLogin::RubySaml::Response.new(saml_idp_resp)
      uid = saml_response.attributes['uid']
      _user = create(:user, uid: uid)
      asserted_attributes = saml_response.attributes.attributes.keys.map(&:to_sym)
      expect(asserted_attributes).to match_array([:uid, :email])

      post '/auth/saml/callback', SAMLResponse: saml_idp_resp

      expect(response).to redirect_to('http://www.example.com/')
    end
  end

  context 'user is an admin' do
    it 'uses external SAML IdP to sign in the user' do
      get '/auth/saml'
      expect(response).to redirect_to(%r{idp\.example\.com\/saml\/auth})

      idp_uri = URI(response.headers['Location'])
      saml_idp_resp = Net::HTTP.get(idp_uri)

      saml_response = OneLogin::RubySaml::Response.new(saml_idp_resp)
      uid = saml_response.attributes['uid']
      _admin_user = create(:admin_user, uid: uid)
      asserted_attributes = saml_response.attributes.attributes.keys.map(&:to_sym)
      expect(asserted_attributes).to match_array([:uid, :email])

      post '/auth/saml/callback', SAMLResponse: saml_idp_resp

      expect(response).to redirect_to('http://www.example.com/admin/auctions/needs_attention')
    end
  end
end
