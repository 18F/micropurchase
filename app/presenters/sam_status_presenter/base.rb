class SamStatusPresenter::Base
  def flash_message(flash)
    flash.now[flash_type] = message
  end

  def flash_type
    fail NotImplementedError
  end

  def admin_status_text
    status_text
  end

  def status_class
    ''
  end

  def status_text
    ''
  end

  def message
    fail NotImplementedError
  end
end
