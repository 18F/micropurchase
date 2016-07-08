class AuctionApprovedJob < ActiveJob::Base
  queue_as :default

  def perform(auction_id)
    auction = Auction.find(auction_id)
    AuctionAcceptedEmailSender.new(auction).perform
  end
end
