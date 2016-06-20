class GuestPresenter
  def sam_status_message_for(_flash)
    nil
  end

  def sam_status_message_for_auctions_index(_flash)
    nil
  end

  def nav_drawer_partial
    "components/guest_nav_drawer"
  end

  def win_header_partial
    "auctions/multi_bid/guest_win_header"
  end

  def nav_drawer_submenu_partial
    "components/guest_nav_drawer_submenu"
  end

  def welcome_message_partial
    'components/welcome_message'
  end

  def admin_edit_auction_partial
    'components/null'
  end
end
