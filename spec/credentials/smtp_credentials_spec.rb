require 'rails_helper'

describe SMTPCredentials do
  context 'using env var' do
    it 'returns correct value' do
      env_var_smtp_password = 'fake smtp password'
      env_var_smtp_username = 'fake smtp username'
      env_var_default_url_host = 'fake url host'
      env_var_defalt_from = 'fake default from'
      ENV['SMTP_PASSWORD'] =  env_var_smtp_password
      ENV['SMTP_USERNAME'] = env_var_smtp_username
      ENV['DEFAULT_URL_HOST'] = env_var_default_url_host
      ENV['DEFAULT_EMAIL_FROM'] = env_var_defalt_from

      password = SMTPCredentials.smtp_password(force_vcap: false)
      username = SMTPCredentials.smtp_username(force_vcap: false)
      url_host = SMTPCredentials.default_url_host(force_vcap: false)
      from = SMTPCredentials.default_from(force_vcap: false)

      expect(password).to eq env_var_smtp_password
      expect(username).to eq env_var_smtp_username
      expect(url_host).to eq env_var_default_url_host
      expect(from).to eq env_var_defalt_from
    end
  end

  context 'parsing user provided service' do
    it 'returns correct value' do
      smtp_password_from_fixture = 'fakesmtppassword'
      smtp_username_from_fixture = 'fakesmtpusername'
      default_url_host_from_fixture = 'fakeurlhost.com'
      default_from_from_fixture = 'info@localhost:3000'

      password = SMTPCredentials.smtp_password(force_vcap: true)
      username = SMTPCredentials.smtp_username(force_vcap: true)
      url_host = SMTPCredentials.default_url_host(force_vcap: true)
      from = SMTPCredentials.default_from(force_vcap: true)

      expect(password).to eq smtp_password_from_fixture
      expect(username).to eq smtp_username_from_fixture
      expect(url_host).to eq default_url_host_from_fixture
      expect(from).to eq default_from_from_fixture
    end
  end
end
