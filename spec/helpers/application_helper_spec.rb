require 'rails_helper'
describe ApplicationHelper do
  describe 'logout_path_for_auth_type' do
    it 'returns saml logout path for saml auth type' do
      session[:auth_type] = "saml"
      expect(logout_path_for_auth_type).to eq(auth_saml_logout_path)
    end 

    it 'returns regular logout path for any other auth type' do
      session[:auth_type] = "notsaml"
      expect(logout_path_for_auth_type).to eq(logout_path)
    end 
  end
end
