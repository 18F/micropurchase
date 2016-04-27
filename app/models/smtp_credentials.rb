class SMTPCredentials
  extend UserProvidedService

  def self.smtp_password(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['SMTP_PASSWORD']
    else
      credentials('micropurchase-smtp')['smtp_password']
    end
  end

  def self.smtp_username(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['SMTP_USERNAME']
    else
      credentials('micropurchase-smtp')['smtp_username']
    end
  end

  def self.default_url_host(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['DEFAULT_URL_HOST']
    else
      credentials('micropurchase-smtp')['default_url_host']
    end
  end

  def self.default_from(force_vcap: false)
    if use_env_var?(force_vcap)
      ENV['DEFAULT_EMAIL_FROM']
    else
      credentials('micropurchase-smtp')['default_from']
    end
  end
end
