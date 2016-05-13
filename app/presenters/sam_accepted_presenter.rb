class SamAcceptedPresenter < SamStatusPresenter
  def flash_type
    :success
  end

  def message
    "Your DUNS number has been verified in Sam.gov"
  end
end
