class Guest
  def github_id
    nil
  end

  def decorate
    GuestPresenter.new
  end

  def id
    nil
  end

  def sam_accepted?
    false
  end

  def nav_drawer_partial
    "components/guest_user_nav_drawer"
  end

  def guest?
    true
  end
end
