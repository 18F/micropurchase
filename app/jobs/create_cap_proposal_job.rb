class CreateCapProposalJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id)
    auction = Auction.find(auction_id)
    CreateCapProposal.new(auction).perform
  end
end
