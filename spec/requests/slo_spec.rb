require 'rails_helper'

describe 'SLO' do
  it 'uses external SAML IdP' do
    OmniAuth.config.test_mode = false

    # ask the IdP to initiate a SLO
    idp_uri = URI('http://idp.example.com/saml/logout')
    saml_idp_resp = Net::HTTP.get(idp_uri)

    # send the SAMLRequest to our logout endpoint
    post '/auth/saml/logout', SAMLRequest: saml_idp_resp, RelayState: 'the_idp_session_id'

    # redirect to complete the sign-out at the IdP
    expect(response).to redirect_to(%r{idp.example.com/saml/logout})
  end
end
