class CreateC2ProposalJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id)
    auction = Auction.find(auction_id)
    CreateC2Proposal.new(auction).perform
  end
end
