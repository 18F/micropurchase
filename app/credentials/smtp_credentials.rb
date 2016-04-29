class SMTPCredentials
  def self.smtp_password
    ENV["micropurchase_smtp_smtp_password"]
  end

  def self.smtp_username
    ENV["micropurchase_smtp_smtp_username"]
  end

  def self.default_url_host
    ENV["micropurchase_smtp_default_url_host"]
  end

  def self.default_from
    ENV["micropurchase_smtp_default_from"]
  end
end
