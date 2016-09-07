module ApplicationHelper
  def masquerading_partial
    if session[:admin_id].present?
      'components/stop_masquerading'
    else
      'components/null'
    end
  end
end
