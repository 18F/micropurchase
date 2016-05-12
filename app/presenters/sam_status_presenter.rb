class SamStatusPresenter
  def flash_message(flash)
    flash.now[flash_type] = message
  end

  def flash_type
    fail NotImplementedError
  end

  def message
    fail NotImplementedError
  end
end
