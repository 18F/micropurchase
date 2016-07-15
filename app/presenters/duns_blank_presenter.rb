class DunsBlankPresenter < SamStatusPresenter
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def flash_type
    :warning
  end

  def message
    "In order to bid, you must supply a valid DUNS number. Please update
    #{link_to 'your profile', profile_path}"
  end
end
