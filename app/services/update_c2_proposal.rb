class UpdateC2Proposal < C2ApiWrapper
  def initialize(auction, attributes_class)
    @auction = auction
    @attributes_class = attributes_class
  end

  def perform
    c2_client.put(c2_proposal_path(auction), c2_proposal_attributes)
  end

  private

  attr_reader :auction, :attributes_class

  def c2_proposal_attributes
    attributes_class.new(auction).perform
  end
end
