class C2ApiWrapper
  protected

  def c2_client
    @c2_client ||= configure_c2_client
  end

  def proposal_json(auction)
    c2_client.get(cap_proposal_path(auction))
  end

  def cap_proposal_path(auction)
    auction.cap_proposal_url.gsub("#{C2Credentials.host}/", "")
  end

  def configure_c2_client
    C2::Client.new(
      oauth_key: C2Credentials.oauth_key,
      oauth_secret: C2Credentials.oauth_secret,
      host: C2Credentials.host,
      debug: ENV.fetch('C2_DEBUG', false)
    )
  end
end
