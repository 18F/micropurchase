class DunsBlankPresenter < SamStatusPresenter
  def flash_type
    :warning
  end

  def message
    "You must supply a valid DUNS number"
  end
end
