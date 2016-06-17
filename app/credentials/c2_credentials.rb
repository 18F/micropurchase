class C2Credentials
  def self.host
    ENV['C2_HOST']
  end

  def self.oauth_key
    ENV['MICROPURCHASE_C2_OAUTH_KEY']
  end

  def self.oauth_secret
    ENV['MICROPURCHASE_C2_OAUTH_SECRET']
  end
end
