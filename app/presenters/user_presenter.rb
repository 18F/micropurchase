class UserPresenter < SimpleDelegator
  def github_json_url
    "https://api.github.com/user/#{github_id}"
  end

  def admin?
    Admins.verify?(model.github_id)
  end

  def in_sam?
    model.sam_status
  end

  def sam_status_message_for(flash)
    Object.const_get("#{model.sam_status.camelize}Presenter").new.flash_message(flash)
  end

  def nav_drawer_partial
    "components/user_nav_drawer"
  end

  def model
    __getobj__
  end
end
