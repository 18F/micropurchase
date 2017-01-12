class SamlAuthenticationsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.from_saml_omniauth(request.env['omniauth.auth'])

    if user
      session[:user_id] = user.id
      session[:auth_type] = "saml"
      redirect_to admin_auctions_needs_attention_path, notice: t('omniauth_callbacks.success')
    else
      flash[:error] = t('omniauth_callbacks.failure', reason: 'no admin account found')
      redirect_to root_path
    end
  end

  def destroy
    if params[:SAMLRequest]
      idp_logout_request
    elsif params[:SAMLResponse]
      validate_slo_response
    else
      sp_logout_request
    end
  end

  def setup
    if params.key?(:loa)
      request.env['omniauth.strategy'].options[:authn_context] = [
        "http://idmanagement.gov/ns/assurance/loa/#{params[:loa]}",
        'http://idmanagement.gov/ns/requested_attributes?ReqAttr=email'
      ]
    end
    render text: 'Omniauth setup phase.', status: 404
  end

  private

  def idp_logout_request
    logout_request = OneLogin::RubySaml::SloLogoutrequest.new(
      params[:SAMLRequest],
      settings: saml_settings
    )
    if logout_request.is_valid?
      redirect_to_logout(logout_request)
    else
      render_logout_error
    end
  end

  def saml_settings
    @_saml_settings ||= OneLogin::RubySaml::Settings.new(SAML_SETTINGS)
  end

  def redirect_to_logout(logout_request)
    Rails.logger.info "IdP initiated Logout for #{logout_request.nameid}"
    sign_out
    logout_response = OneLogin::RubySaml::SloLogoutresponse.new.create(
      saml_settings,
      logout_request.id,
      nil,
      RelayState: params[:RelayState]
    )
    redirect_to logout_response
    reset_session
  end

  def render_logout_error(logout_request)
    error_msg = "IdP initiated LogoutRequest was not valid: #{logout_request.errors}"
    Rails.logger.error error_msg
    render inline: error_msg
  end

  def validate_slo_response
    slo_response = idp_logout_response
    if slo_response.validate
      flash[:notice] = t('omniauth_callbacks.logout_ok')
      redirect_to root_url
    else
      flash[:alert] = t('omniauth_callbacks.logout_fail')
      redirect_to failure_url
    end
  end

  def idp_logout_response
    OneLogin::RubySaml::Logoutresponse.new(params[:SAMLResponse], saml_settings)
  end

  def sp_logout_request
    settings = saml_settings.dup
    settings.name_identifier_value = current_user.uid
    logout_request = OneLogin::RubySaml::Logoutrequest.new.create(settings)
    redirect_to logout_request
  end

  def sign_out
    # no-op
  end
end
