class UpdateCapProposalJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id)
    auction = Auction.find(auction_id)
    UpdateCapProposal.new(auction).perform
  end
end
