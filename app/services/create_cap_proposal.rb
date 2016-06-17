class CreateCapProposal
  class Error < StandardError; end

  def initialize(auction)
    @auction = auction
  end

  def perform
    cap_proposal_attributes = ConstructCapAttributes.new(@auction).perform
    resp = c2_client.post('proposals', cap_proposal_attributes)
    proposal = resp.body
    proposal_url = construct_proposal_url(proposal.id)
    add_cap_proposal_url_to_auction!(proposal_url)
    return proposal_url
  rescue Faraday::ClientError => error
    raise CreateCapProposal::Error, error
  end

  private

  attr_reader :auction

  def add_cap_proposal_url_to_auction!(cap_proposal_url)
    auction.update(cap_proposal_url: cap_proposal_url)
  end

  def c2_client
    @c2_client ||= configure_c2_client
  end

  def configure_c2_client
    C2::Client.new(
      oauth_key: C2Credentials.oauth_key,
      oauth_secret: C2Credentials.oauth_secret,
      host: C2Credentials.host,
      debug: ENV.fetch('C2_DEBUG', false)
    )
  end

  def construct_proposal_url(id)
    "#{C2Credentials.host}/proposals/#{id}"
  end
end
