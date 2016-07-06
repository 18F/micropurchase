class CreateCapProposal < C2ApiWrapper
  class Error < StandardError; end

  def initialize(auction)
    @auction = auction
  end

  def perform
    auction.update(cap_proposal_url: proposal_url)
  rescue Faraday::ClientError => error
    raise CreateCapProposal::Error, error
  end

  private

  attr_reader :auction

  def proposal_url
    "#{C2Credentials.host}/proposals/#{proposal.id}"
  end

  def proposal
    c2_response.body
  end

  def c2_response
    c2_client.post('proposals', c2_proposal_attributes)
  end

  def c2_proposal_attributes
    ConstructCapAttributes.new(auction).perform
  end
end
