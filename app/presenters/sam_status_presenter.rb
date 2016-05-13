class SamStatusPresenter
  def auctions_index_flash_message(flash)
    flash.now[flash_type] = index_specific_message
  end

  def flash_message(flash)
    flash.now[flash_type] = message
  end

  def flash_type
    fail NotImplementedError
  end

  def index_specific_message
    index_message || message
  end

  def index_message
    nil
  end

  def message
    fail NotImplementedError
  end
end
