require 'rails_helper'

describe SMTPCredentials do
  context 'using env var' do
    it 'returns correct value' do
      env_var_smtp_password = 'fake smtp password'
      env_var_smtp_username = 'fake smtp username'
      env_var_default_url_host = 'fake url host'
      allow(ENV).to receive(:[]).with('micropurchase_smtp_smtp_password').and_return(env_var_smtp_password)
      allow(ENV).to receive(:[]).with('micropurchase_smtp_smtp_username').and_return(env_var_smtp_username)
      allow(ENV).to receive(:[]).with('micropurchase_smtp_default_url_host').and_return(env_var_default_url_host)

      password = SMTPCredentials.smtp_password
      username = SMTPCredentials.smtp_username
      url_host = SMTPCredentials.default_url_host

      expect(password).to eq env_var_smtp_password
      expect(username).to eq env_var_smtp_username
      expect(url_host).to eq env_var_default_url_host
    end
  end
end
