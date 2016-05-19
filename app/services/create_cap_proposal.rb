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

  def configure_c2_client
    @host = ENV.fetch('C2_HOST', 'https://c2-dev.18f.gov')
    @c2_client = C2::Client.new(
      oauth_key: ENV.fetch('MICROPURCHASE_C2_OAUTH_KEY'),
      oauth_secret: ENV.fetch('MICROPURCHASE_C2_OAUTH_SECRET'),
      host: @host,
      debug: ENV.fetch('C2_DEBUG', false)
    )

    @c2_client
  end

  def c2_client
    @c2_client ||= configure_c2_client
  end

  def construct_proposal_url(id)
    "#{@host}/proposals/#{id}"
  end
end
