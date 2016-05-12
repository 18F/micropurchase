class SamRejectedPresenter < SamStatusPresenter
  def flash_type
    :error
  end

  def message
    "Your DUNS number was not found in Sam.gov. Please enter a valid DUNS number
    to complete your profile. Check
    https://www.sam.gov/sam/helpPage/SAM_Reg_Status_Help_Page.html to make sure
    your DUNS number is correct. If you need any help email us at
    micropurchase@gsa.gov"
  end
end
