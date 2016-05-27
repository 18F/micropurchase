class NewRelicCredentials
  def license_key
    ENV['MICROPURCHASE_NEW_RELIC_LICENSE_KEY']
  end
end
