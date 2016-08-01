class GuestPresenter
  def sam_status_message_for(_flash)
    nil
  end

  def nav_drawer_partial
    "components/guest_nav_drawer"
  end

  def welcome_message_partial
    'components/welcome_message'
  end

  def admin_edit_auction_partial
    'components/null'
  end
end
