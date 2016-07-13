class UpdateC2Proposal < C2ApiWrapper
  def initialize(auction)
    @auction = auction
  end

  def perform
    c2_client.put(c2_proposal_path(auction), c2_proposal_attributes)
  end

  private

  attr_reader :auction

  def c2_proposal_attributes
    UpdateC2Attributes.new(auction).perform
  end
end
