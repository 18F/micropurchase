class SamAccountReckoner < Struct.new(:user)
  def set_default_sam_status
    if should_clear_status?
      user.sam_status = :sam_pending
    elsif user.duns_number.blank?
      user.sam_status = :duns_blank
    end
  end

  def set!
    if user.sam_pending?
      user.sam_status = sam_status
      user.save!
    end
  end

  private

  def should_clear_status?
    user.persisted? && user.duns_number_changed?
  end

  def sam_status
    if client.duns_is_in_sam?(duns: user.duns_number)
      :sam_accepted
    else
      :sam_rejected
    end
  end

  def client
    @client ||= Samwise::Client.new(api_key: DataDotGovCredentials.api_key)
  end
end
