require 'rails_helper'

RSpec.describe SMTPCredentials do
  describe '::smtp_password' do
    let(:smtp_password) { SMTPCredentials.smtp_password(force_vcap: true) }
    it 'should return the smtp_password' do
      smtp_password_from_fixture = "fakesmtppassword"
      expect(smtp_password).to eq(smtp_password_from_fixture)
    end
  end

  describe '::smtp_username' do
    let(:smtp_username) { SMTPCredentials.smtp_username(force_vcap: true) }
    it 'should return the smtp_username' do
      smtp_username_from_fixture = "fakesmtpusername"
      expect(smtp_username).to eq(smtp_username_from_fixture)
    end
  end

  describe '::default_url_host' do
    let(:default_url_host) { SMTPCredentials.default_url_host(force_vcap: true) }
    it 'should return the default_url_host' do
      default_url_host_from_fixture = "fakeurlhost.com"
      expect(default_url_host).to eq(default_url_host_from_fixture)
    end
  end
end
