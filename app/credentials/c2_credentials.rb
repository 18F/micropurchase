class C2Credentials
  def self.host
    ENV.fetch('C2_HOST', 'https://c2-dev.18f.gov')
  end

  def self.oauth_key
    ENV['MICROPURCHASE_C2_OAUTH_KEY']
  end

  def self.oauth_secret
    ENV['MICROPURCHASE_C2_OAUTH_SECRET']
  end
end
