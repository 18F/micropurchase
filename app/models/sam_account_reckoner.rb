class SamAccountReckoner < Struct.new(:user)
  def set_default_sam_status
    if should_clear_status?
      user.sam_status = :sam_pending
    elsif user.duns_number.blank?
      user.sam_status = :duns_blank
    end
  end

  def set!
    update_sam_status
    update_small_business

    if user.changed?
      user.save
    end
  end

  private

  def update_small_business
    if user.sam_accepted?
      user.small_business = duns_is_small_business?
    end
  end

  def update_sam_status
    if user.sam_pending?
      user.sam_status = sam_status
    end
  end

  def should_clear_status?
    user.persisted? && user.duns_number_changed?
  end

  def sam_status
    if duns_is_in_sam?
      :sam_accepted
    else
      :sam_rejected
    end
  end

  def client
    @client ||= Samwise::Client.new(api_key: DataDotGovCredentials.api_key)
  end

  def vendor_summary
    @vendor_summary ||= client.get_vendor_summary(duns: user.duns_number)
  end

  def duns_is_in_sam?
    vendor_summary[:in_sam]
  end

  def duns_is_small_business?
    vendor_summary[:small_business]
  end
end
