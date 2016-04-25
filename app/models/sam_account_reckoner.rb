class SamAccountReckoner < Struct.new(:user)
  def clear
    if should_clear?
      user.sam_status = :sam_pending
    end
  end

  def self.unreckoned
    User.where(sam_status: 0)
  end

  def set
    if user.sam_pending?
      user.sam_status = sam_status
    end
  end

  def set!
    set
    user.save!
  end

  private

  def should_clear?
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
