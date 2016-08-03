require 'concerns/user_provided_service'

class SMTPCredentials
  extend UserProvidedService

  def self.smtp_password
    if use_env_var?
      ENV['MICROPURCHASE_SMTP_SMTP_PASSWORD']
    else
      credentials('micropurchase-smtp')['smtp_password']
    end
  end

  def self.smtp_username
    if use_env_var?
      ENV['MICROPURCHASE_SMTP_SMTP_USERNAME']
    else
      credentials('micropurchase-smtp')['smtp_username']
    end
  end

  def self.default_url_host
    if use_env_var?
      ENV['MICROPURCHASE_SMTP_DEFAULT_URL_HOST']
    else
      credentials('micropurchase-smtp')['default_urL_host']
    end
  end

  def self.default_from
    if use_env_var?
      ENV['MICROPURCHASE_SMTP_DEFAULT_FROM']
    else
      credentials('micropurchase-smtp')['default_from']
    end
  end
end
