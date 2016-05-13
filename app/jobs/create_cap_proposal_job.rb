class CreateCapProposalJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id)
    auction = Auction.find(auction_id)
    auction_presenter = AuctionPresenter.new(auction)
    CreateCapProposal.new(auction_presenter).perform
  end
end
