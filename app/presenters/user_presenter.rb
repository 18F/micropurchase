class UserPresenter < SimpleDelegator
  def github_json_url
    "https://api.github.com/user/#{github_id}"
  end

  def admin?
    Admins.verify?(model.github_id)
  end

  def in_sam?
    model.sam_accepted?
  end

  def sam_status_message_for(flash)
    sam_status_presenter.flash_message(flash)
  end

  def sam_status_message_for_auctions_index(flash)
    sam_status_presenter.auctions_index_flash_message(flash)
  end

  def nav_drawer_partial
    "components/user_nav_drawer"
  end

  def win_header_partial
    "auctions/multi_bid/user_win_header"
  end

  def nav_drawer_submenu_partial
    "components/user_nav_drawer_submenu"
  end

  def welcome_message_partial
    'components/null'
  end
  
  def sam_status_label
    in_sam? ? 'Yes' : 'No'
  end

  def small_business_label
    if in_sam?
      small_business? ? 'Yes' : 'No'
    else
      'N/A'
    end
  end

  def model
    __getobj__
  end

  private

  def sam_status_presenter
    Object.const_get("#{model.sam_status.camelize}Presenter").new
  end
end
