require 'rails_helper'

describe SMTPCredentials do
  context 'using env var' do
    it 'returns correct value' do
      env_var_smtp_password = 'fake smtp password'
      env_var_smtp_username = 'fake smtp username'
      env_var_default_url_host = 'fake url host'
      allow(ENV).to receive(:[]).with('SMTP_PASSWORD').and_return(env_var_smtp_password)
      allow(ENV).to receive(:[]).with('SMTP_USERNAME').and_return(env_var_smtp_username)
      allow(ENV).to receive(:[]).with('DEFAULT_URL_HOST').and_return(env_var_default_url_host)

      password = SMTPCredentials.smtp_password
      username = SMTPCredentials.smtp_username
      url_host = SMTPCredentials.default_url_host

      expect(password).to eq env_var_smtp_password
      expect(username).to eq env_var_smtp_username
      expect(url_host).to eq env_var_default_url_host
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
      from = SMTPCredentials.default_from

      expect(password).to eq smtp_password_from_fixture
      expect(username).to eq smtp_username_from_fixture
      expect(url_host).to eq default_url_host_from_fixture
      expect(from).to eq default_from_from_fixture
    end
  end
end
