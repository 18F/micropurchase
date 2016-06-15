class CapPaymentChecker
  def perform
    AuctionQuery.new.payment_pending.each do |auction|
      paid_at = find_purchase_timestamp(proposal_json(auction))

      if paid_at
        auction.update(paid_at: DateTime.new.iso8601(paid_at))
      end
    end
  end

  private

  def find_purchase_timestamp(proposal_json)
    parsed_json = JSON.parse(proposal_json)
    purchase_step = parsed_json['steps'].detect do |step|
      step["type"] == "Steps::Purchase"
    end

    purchase_step['completed_at']
  end

  def proposal_json(auction)
    c2_client.get(cap_proposal_path(auction))
  end

  def c2_client
    @c2_client ||= configure_c2_client
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
