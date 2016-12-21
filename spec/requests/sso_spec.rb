require 'rails_helper'

describe 'SSO' do
  it 'uses external SAML IdP' do
    OmniAuth.config.test_mode = false
    expect(User.count).to eq 0

    get '/auth/saml'
    expect(response).to redirect_to(/idp\.example\.com\/saml\/auth/)

    idp_uri = URI(response.headers['Location'])
    saml_idp_resp = Net::HTTP.get(idp_uri)

    post '/auth/saml/callback', SAMLResponse: saml_idp_resp

    expect(response).to redirect_to('http://www.example.com/success')
    expect(User.count).to eq 1
  end
end
