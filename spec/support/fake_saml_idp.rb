require 'sinatra/base'
require 'saml_idp/controller'
require 'saml_idp/logout_request_builder'

class FakeSamlIdp < Sinatra::Base
  include SamlIdp::Controller

  get '/saml/auth' do
    build_configs
    validate_saml_request
    encode_response(user)
  end

  get '/saml/logout' do
    build_configs
    logout_request_builder.signed
  end

  private

  def logout_request_builder
    session_index = SecureRandom.uuid
    SamlIdp::LogoutRequestBuilder.new(
      session_index,
      SamlIdp.config.base_saml_location,
      'foo/bar/logout',
      user.id,
      OpenSSL::Digest::SHA256
    )
  end

  def build_configs
    SamlIdp.configure do |config|
      idp_base_url = 'http://idp.example.com'

      # for convenience we use the same cert/key pair as the SP
      # but in real-life these would be different.
      # NOTE that x509_certificate fingerprint is defined in config/secrets.yml
      # so that the SP can correctly decode our response.
      config.x509_certificate = File.read("#{Rails.root}/certs/sp/micropurchase_sp.crt")
      config.secret_key = File.read("#{Rails.root}/keys/saml_test_sp.key")

      config.base_saml_location = "#{idp_base_url}/saml"
      config.single_service_post_location = "#{idp_base_url}/saml/auth"
      config.single_logout_service_post_location = "#{idp_base_url}/saml/logout"

      config.name_id.formats = {
        persistent: -> (principal) { principal.uid },
        email_address: -> (principal) { principal.email }
      }

      config.attributes = {
        uid: {
          getter: :uid,
          name_format: Saml::XML::Namespaces::Formats::NameId::PERSISTENT,
          name_id_format: Saml::XML::Namespaces::Formats::NameId::PERSISTENT
        },
        email: {
          getter: :email,
          name_format: Saml::XML::Namespaces::Formats::NameId::EMAIL_ADDRESS,
          name_id_format: Saml::XML::Namespaces::Formats::NameId::EMAIL_ADDRESS
        }
      }

      config.service_provider.finder = lambda do |_issuer_or_entity_id|
        {
          cert: config.x509_certificate,
          private_key: config.secret_key
        }
      end
    end
  end

  def user
    FactoryGirl.build(
      :user,
      uid: SecureRandom.uuid,
      email: 'fakeuser@example.com'
    )
  end
end
