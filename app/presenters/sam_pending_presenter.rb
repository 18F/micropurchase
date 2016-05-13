class SamPendingPresenter < SamStatusPresenter
  def flash_type
    :warning
  end

  def message
    "Your profile is pending while your DUNS number is being validated. This
    typically takes less than one hour"
  end
end
