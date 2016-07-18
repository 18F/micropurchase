class EditUserViewModel
  def initialize(user)
    @user = user
  end

  def sam_status_icon_class
    "#{sam_status_class}-verification-status-icon"
  end

  def sam_status_text_class
    "#{sam_status_class}-verification-status-text"
  end

  def sam_status_text
    sam_status_presenter.status_text
  end

  def record
    user
  end

  private

  attr_reader :user

  def sam_status_class
    sam_status_presenter.status_class
  end

  def sam_status_presenter
    Object.const_get("#{user.sam_status.camelize}Presenter").new
  end
end
