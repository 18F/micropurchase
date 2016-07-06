class UpdateCapProposal < C2ApiWrapper
  def initialize(auction)
    @auction = auction
  end

  def perform
    c2_client.put(cap_proposal_path(auction), c2_proposal_attributes)
  end

  private

  attr_reader :auction

  def c2_proposal_attributes
    UpdateCapAttributes.new(auction).perform
  end
end
