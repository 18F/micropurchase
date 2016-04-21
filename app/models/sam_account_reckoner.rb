class SamAccountReckoner < Struct.new(:user)
  def clear
    user.sam_account = false if should_clear?
  end

  def self.unreckoned
    User.where(sam_account: false)
  end

  def set
    if !user.sam_account?
      user.sam_account = user_in_sam?
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

  def user_in_sam?
    client.duns_is_in_sam?(duns: user.duns_number)
  end

  def client
    @client ||= Samwise::Client.new(api_key: DataDotGovCredentials.api_key)
  end
end
