module ApplicationHelper
  def masquerading_partial
    if session[:admin_id].present?
      'components/stop_masquerading'
    else
      'components/null'
    end
  end

  def logout_path_for_auth_type
    if session[:auth_type] == 'saml'
      auth_saml_logout_path
    else
      logout_path
    end
  end
end
