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
    sam_status_presenter.flash_message(flash)
  end

  def sam_status_message_for_auctions_index(flash)
    sam_status_presenter.auctions_index_flash_message(flash)
  end

  def nav_drawer_partial
    "components/user_nav_drawer"
  end

  def small_business_label
    if model.sam_accepted?
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
