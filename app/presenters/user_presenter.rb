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

  def nav_drawer_partial
    "components/user_nav_drawer"
  end

  def nav_drawer_admin_link
    "components/null"
  end

  def welcome_message_partial
    'components/null'
  end

  def admin_user_page_link_partial
    'components/admin_user_page_link'
  end

  def admin_edit_auction_partial
    if admin?
      'auctions/edit_auction_link'
    else
      'components/null'
    end
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
    SamStatusPresenterFactory.new(model).create
  end
end
