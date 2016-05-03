class SMTPCredentials
  def self.smtp_password
    ENV["MICROPURCHASE_SMTP_SMTP_PASSWORD"]
  end

  def self.smtp_username
    ENV["MICROPURCHASE_SMTP_SMTP_USERNAME"]
  end

  def self.default_url_host
    ENV["MICROPURCHASE_SMTP_DEFAULT_URL_HOST"]
  end

  def self.default_from
    ENV["MICROPURCHASE_SMTP_DEFAULT_FROM"]
  end
end
