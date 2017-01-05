class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    if add_saml_to_user?
      if User.from_omniauth(request.env['omniauth.auth'])
        redirect_to(
          profile_path, 
          notice: t('omniauth_callbacks.duplicate')
        )
      else
        add_saml_to_user
      end
    else
      login_saml_user
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
        'http://idmanagement.gov/ns/requested_attributes?ReqAttr=email,first_name,last_name'
      ]
    end
    render text: 'Omniauth setup phase.', status: 404
  end

  def remove
    if !current_user.guest?
      current_user.uid = ""
      current_user.provider = nil
      current_user.save
    end
    redirect_to(
      profile_path,
      notice: t('omniauth_callbacks.remove_account')
    )
  end

  private

  def login_saml_user
    user = User.from_omniauth(request.env['omniauth.auth'])
    if(user)
      session[:user_id] = user.id
      redirect_back_or_root_path
    else
      redirect_to(
        sign_in_admin_path,
        notice: t('omniauth_callbacks.no_account')
      )
    end
  end

  def add_saml_to_user?
    !current_user.guest? && !current_user.saml_enabled?
  end

  def add_saml_to_user
    current_user.add_saml(request.env['omniauth.auth'])
    if current_user.save
      redirect_to(
        profile_path,
        notice: t('omniauth_callbacks.add_account')
      )
    else
      redirect_to(
        profile_path,
        notice: t('omniauth_callbacks.error')
      )
    end
  end

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

  def redirect_back_or_root_path
    if Admins.verify?(current_user.github_id)
      redirect_to(return_to || admin_auctions_needs_attention_path)
    else
      redirect_to(return_to || root_path)
    end
    clear_return_to
  end

  def return_to
    if return_to_url
      uri = URI.parse(return_to_url)
      "#{uri.path}?#{uri.query}".chomp('?')
    end
  end

  def return_to_url
    session[:return_to]
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
