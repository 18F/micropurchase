class SamAccountReckoner < Struct.new(:user)
  def clear
    user.sam_account = false if should_clear?
  end

  def set
    return true if user.sam_account?
    user.sam_account = client.duns_is_in_sam?(duns: user.duns_number)
  end

  private

  def should_clear?
    user.persisted? && user.duns_number_changed?
  end

  def client
    @client ||= Samwise::Client.new
  end
end
