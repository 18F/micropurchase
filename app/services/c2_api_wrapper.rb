class C2ApiWrapper
  protected

  def c2_client
    @c2_client ||= configure_c2_client
  end

  def proposal_json(auction)
    c2_client.get(c2_proposal_path(auction))
  end

  def c2_proposal_path(auction)
    auction.c2_proposal_url.gsub("#{Credentials.c2_host}/", "")
  end

  def configure_c2_client
    C2::Client.new(
      oauth_key:    Credentials.get('micropurchase-c2', 'oauth_key'),
      oauth_secret: Credentials.get('micropurchase-c2', 'oauth_secret'),
      host:         Credentials.c2_host,
      debug:        ENV.fetch('C2_DEBUG', false)
    )
  end
end
