class UpdateC2ProposalJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id, attributes_classname)
    auction = Auction.find(auction_id)
    attributes_class = attributes_classname.constantize

    UpdateC2Proposal.new(auction, attributes_class).perform
  end
end
