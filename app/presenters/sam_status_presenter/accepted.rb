class SamStatusPresenter::Accepted < SamStatusPresenter::Base
  def flash_type
    :success
  end

  def status_class
    'verified'
  end

  def status_text
    'Verified'
  end

  def message
    "Your DUNS number has been verified in Sam.gov"
  end
end
