class AdminUserPresenter < UserPresenter
  def nav_drawer_admin_link
    "components/admin_nav_link"
  end

  def profile_edit_admin_link
    "components/login_gov"
  end

  def sam_status_message_for(_flash)
    nil
  end
end
